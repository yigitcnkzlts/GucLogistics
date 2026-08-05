package com.guclogistics.offers.application;

import com.guclogistics.offers.application.dto.CreateOfferRequest;
import com.guclogistics.offers.application.dto.OfferResponse;
import com.guclogistics.offers.domain.OfferStatus;
import com.guclogistics.offers.domain.OffererType;
import com.guclogistics.offers.infrastructure.persistence.OfferEntity;
import com.guclogistics.offers.infrastructure.persistence.OfferJpaRepository;
import com.guclogistics.shared.event.DomainEventPublisher;
import com.guclogistics.shared.events.offers.OfferAcceptedEvent;
import com.guclogistics.shared.events.offers.OfferRejectedEvent;
import com.guclogistics.shared.events.offers.OfferSubmittedEvent;
import com.guclogistics.shared.exception.DomainException;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import lombok.RequiredArgsConstructor;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class OfferService {

    private final OfferJpaRepository offerRepository;
    private final DomainEventPublisher eventPublisher;
    private final EntityManager entityManager;

    @Transactional
    public OfferResponse submitOffer(UUID loadId, UUID userId, CreateOfferRequest request) {
        LoadSnapshot load = requirePublishedLoad(loadId);
        UUID offererId = resolveOffererId(userId, request);

        OfferEntity offer = new OfferEntity();
        offer.setLoadId(loadId);
        offer.setOffererType(request.offererType());
        offer.setOffererId(offererId);
        offer.setCreatedByUserId(userId);
        offer.setAmount(request.amount());
        offer.setCurrency(request.currency().toUpperCase());
        offer.setMessage(request.message());
        offer.setValidUntil(request.validUntil());
        offer.setStatus(OfferStatus.PENDING);

        OfferEntity saved;
        try {
            saved = offerRepository.save(offer);
        } catch (DataIntegrityViolationException e) {
            throw DomainException.conflict("A pending offer already exists for this load");
        }

        eventPublisher.publish(new OfferSubmittedEvent(
                saved.getId(),
                saved.getLoadId(),
                saved.getOffererType().name(),
                saved.getOffererId(),
                saved.getCreatedByUserId(),
                saved.getAmount(),
                saved.getCurrency()
        ));

        return toResponse(saved);
    }

    @Transactional
    public OfferResponse accept(UUID offerId, UUID userId) {
        OfferEntity offer = offerRepository.findById(offerId)
                .orElseThrow(() -> DomainException.notFound("Offer not found"));

        LoadSnapshot load = requireLoad(offer.getLoadId());
        if (!load.createdByUserId().equals(userId)) {
            throw DomainException.forbidden("Only the load owner can accept offers");
        }
        if (offer.getStatus() != OfferStatus.PENDING) {
            throw DomainException.business("Only pending offers can be accepted");
        }
        if (!"PUBLISHED".equals(load.status())) {
            throw DomainException.business("Load must be published to accept an offer");
        }

        int updated = entityManager.createNativeQuery("""
                        UPDATE loads
                        SET status = 'MATCHED', version = version + 1, updated_at = NOW()
                        WHERE id = ?1 AND status = 'PUBLISHED' AND version = ?2
                        """)
                .setParameter(1, load.id())
                .setParameter(2, load.version())
                .executeUpdate();

        if (updated == 0) {
            throw DomainException.conflict("Load is no longer available for matching");
        }

        offer.setStatus(OfferStatus.ACCEPTED);
        OfferEntity saved = offerRepository.save(offer);
        offerRepository.rejectOtherPendingOffers(load.id(), saved.getId());

        eventPublisher.publish(new OfferAcceptedEvent(
                saved.getId(),
                saved.getLoadId(),
                load.createdByUserId(),
                saved.getOffererType().name(),
                saved.getOffererId(),
                saved.getCreatedByUserId()
        ));

        return toResponse(saved);
    }

    @Transactional
    public OfferResponse reject(UUID offerId, UUID userId) {
        OfferEntity offer = offerRepository.findById(offerId)
                .orElseThrow(() -> DomainException.notFound("Offer not found"));

        LoadSnapshot load = requireLoad(offer.getLoadId());
        if (!load.createdByUserId().equals(userId)) {
            throw DomainException.forbidden("Only the load owner can reject offers");
        }
        if (offer.getStatus() != OfferStatus.PENDING) {
            throw DomainException.business("Only pending offers can be rejected");
        }

        offer.setStatus(OfferStatus.REJECTED);
        OfferEntity saved = offerRepository.save(offer);

        eventPublisher.publish(new OfferRejectedEvent(
                saved.getId(),
                saved.getLoadId(),
                saved.getCreatedByUserId(),
                userId
        ));

        return toResponse(saved);
    }

    @Transactional
    public OfferResponse withdraw(UUID offerId, UUID userId) {
        OfferEntity offer = offerRepository.findByIdAndCreatedByUserId(offerId, userId)
                .orElseThrow(() -> DomainException.forbidden("Offer not found or access denied"));
        if (offer.getStatus() != OfferStatus.PENDING) {
            throw DomainException.business("Only pending offers can be withdrawn");
        }

        offer.setStatus(OfferStatus.WITHDRAWN);
        return toResponse(offerRepository.save(offer));
    }

    @Transactional(readOnly = true)
    public List<OfferResponse> listMine(UUID userId) {
        return offerRepository.findByCreatedByUserIdOrderByCreatedAtDesc(userId).stream()
                .map(this::toResponse)
                .toList();
    }

    private UUID resolveOffererId(UUID userId, CreateOfferRequest request) {
        if (request.offererType() == OffererType.DRIVER) {
            try {
                return (UUID) entityManager.createNativeQuery("""
                                SELECT id FROM driver_profiles WHERE user_id = ?1
                                """)
                        .setParameter(1, userId)
                        .getSingleResult();
            } catch (NoResultException e) {
                // Independent drivers may offer before profile enrichment in MVP flows
                return userId;
            }
        }
        if (request.offererId() == null) {
            throw DomainException.business("Company offererId is required");
        }
        Number membership = (Number) entityManager.createNativeQuery("""
                        SELECT COUNT(*) FROM company_members WHERE company_id = ?1 AND user_id = ?2
                        """)
                .setParameter(1, request.offererId())
                .setParameter(2, userId)
                .getSingleResult();
        if (membership.longValue() == 0L) {
            throw DomainException.forbidden("You are not a member of the offering company");
        }
        return request.offererId();
    }

    private LoadSnapshot requirePublishedLoad(UUID loadId) {
        LoadSnapshot load = requireLoad(loadId);
        if (!"PUBLISHED".equals(load.status())) {
            throw DomainException.business("Offers can only be submitted for published loads");
        }
        return load;
    }

    private LoadSnapshot requireLoad(UUID loadId) {
        try {
            Object[] row = (Object[]) entityManager.createNativeQuery("""
                            SELECT id, status, created_by_user_id, version
                            FROM loads
                            WHERE id = ?1
                            """)
                    .setParameter(1, loadId)
                    .getSingleResult();
            return new LoadSnapshot(
                    (UUID) row[0],
                    row[1].toString(),
                    (UUID) row[2],
                    ((Number) row[3]).longValue()
            );
        } catch (NoResultException e) {
            throw DomainException.notFound("Load not found");
        }
    }

    private OfferResponse toResponse(OfferEntity offer) {
        return new OfferResponse(
                offer.getId(),
                offer.getLoadId(),
                offer.getOffererType(),
                offer.getOffererId(),
                offer.getCreatedByUserId(),
                offer.getAmount(),
                offer.getCurrency(),
                offer.getMessage(),
                offer.getStatus(),
                offer.getValidUntil(),
                offer.getVersion(),
                offer.getCreatedAt(),
                offer.getUpdatedAt()
        );
    }

    private record LoadSnapshot(UUID id, String status, UUID createdByUserId, long version) {
    }
}

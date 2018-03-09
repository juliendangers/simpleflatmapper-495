package fr.ep.iziglooms.servicetarificationtravaux.calcultarif.domain.dto

import fr.ep.iziglooms.servicetarificationtravaux.persistence.tables.records.AjoutproduitcaracteristiqueRecord
import java.time.Instant

data class AjoutProduitCaracteristiqueDto(
        val id: Int,
        val idAjoutProduit: Int,
        val idCaracteristique: String,
        val valueCaracteristique: String,
        val dateCreation: Instant,
        val dateMiseAJour: Instant?,
        val conditions: List<ConditionAjoutElement> = emptyList()
) {
    companion object {
        fun fromRecord(ajoutProduitCaracteristique: AjoutproduitcaracteristiqueRecord, conditions: List<ConditionAjoutElement> = emptyList()) =
                AjoutProduitCaracteristiqueDto(
                        ajoutProduitCaracteristique.idajoutproduitcaracteristique,
                        ajoutProduitCaracteristique.idajoutproduit,
                        ajoutProduitCaracteristique.idcaracteristique,
                        ajoutProduitCaracteristique.valuecaracteristique,
                        ajoutProduitCaracteristique.datecreation.toInstant(),
                        ajoutProduitCaracteristique.datemiseajour.toInstant(),
                        conditions
                )
    }
}

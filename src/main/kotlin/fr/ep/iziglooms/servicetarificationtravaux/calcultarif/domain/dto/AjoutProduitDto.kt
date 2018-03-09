package fr.ep.iziglooms.servicetarificationtravaux.calcultarif.domain.dto

import fr.ep.iziglooms.servicetarificationtravaux.persistence.tables.records.AjoutproduitRecord
import java.time.Instant

data class AjoutProduitDto(
        val id: Int,
        val idCalculTarif: Int,
        val variableQuantite: String?,
        val idProduit: String,
        val dateCreation: Instant,
        val dateMiseAJour: Instant?,
        val caracteristiques: List<AjoutProduitCaracteristiqueDto> = emptyList(),
        val conditions: List<ConditionAjoutElement> = emptyList()
) {
    companion object {
        fun fromRecord(ajoutProduit: AjoutproduitRecord,
                       conditions: List<ConditionAjoutElement> = emptyList(),
                       caracteristiques: List<AjoutProduitCaracteristiqueDto> = emptyList()) =
                AjoutProduitDto(
                        ajoutProduit.idajoutproduit,
                        ajoutProduit.idcalcultarif,
                        ajoutProduit.variablequantite,
                        ajoutProduit.idproduit,
                        ajoutProduit.datecreation.toInstant(),
                        ajoutProduit.datemiseajour.toInstant(),
                        caracteristiques,
                        conditions
                )
    }
}

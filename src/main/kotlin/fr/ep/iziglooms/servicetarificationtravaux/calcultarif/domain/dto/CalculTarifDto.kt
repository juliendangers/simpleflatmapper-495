package fr.ep.iziglooms.servicetarificationtravaux.calcultarif.domain.dto

import fr.ep.iziglooms.servicetarificationtravaux.persistence.tables.records.CalcultarifRecord
import java.time.Instant

data class CalculTarifDto(
        val id: Int,
        val nom: String,
        val action: String,
        val dateCreation: Instant,
        val dateMiseAJour: Instant?,
        val produits: List<AjoutProduitDto> = emptyList()
) {
    companion object {
        fun fromRecord(calculTarif: CalcultarifRecord, produits: List<AjoutProduitDto> = emptyList()) =
                CalculTarifDto(
                        calculTarif.idcalcultarif,
                        calculTarif.nom,
                        calculTarif.action,
                        calculTarif.datecreation.toInstant(),
                        calculTarif.datemiseajour?.toInstant(),
                        produits
                )
    }
}

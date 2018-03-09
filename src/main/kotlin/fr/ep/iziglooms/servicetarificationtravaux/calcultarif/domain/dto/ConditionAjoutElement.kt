package fr.ep.iziglooms.servicetarificationtravaux.calcultarif.domain.dto

import fr.ep.iziglooms.servicetarificationtravaux.persistence.tables.records.ConditionajoutproduitRecord
import fr.ep.iziglooms.servicetarificationtravaux.persistence.tables.records.ConditionajoutproduitcaracteristiqueRecord
import java.time.Instant

data class ConditionAjoutElement(
        val id: Int,
        val idElement: Int,
        val variableName: String,
        val operator: String,
        val valueCondition: String,
        val dateCreation: Instant,
        val dateMiseAJour: Instant?
) {
    companion object {
        fun fromRecord(condition: ConditionajoutproduitRecord) =
                ConditionAjoutElement(
                        condition.idconditionajoutproduit,
                        condition.idajoutproduit,
                        condition.variablename,
                        condition.idconditionoperator,
                        condition.valuecondition,
                        condition.datecreation.toInstant(),
                        condition.datemiseajour?.toInstant()
                )

        fun fromRecord(condition: ConditionajoutproduitcaracteristiqueRecord): ConditionAjoutElement {
            return ConditionAjoutElement(
                    condition.idconditionajoutproduitcaracteristique,
                    condition.idajoutproduitcaracteristique,
                    condition.variablename,
                    condition.idconditionoperator,
                    condition.valuecondition,
                    condition.datecreation.toInstant(),
                    condition.datemiseajour?.toInstant()
            )
        }
    }
}

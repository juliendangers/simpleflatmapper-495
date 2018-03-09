package fr.ep.iziglooms.servicetarificationtravaux.calcultarif.domain.dto

import fr.ep.iziglooms.servicetarificationtravaux.persistence.tables.records.VariablecalcultarifRecord
import java.time.Instant

data class VariableCalculTarif (
        val idCalculTarif: Int,
        val variableName: String,
        val variableType: VariableType,
        val dateCreation: Instant,
        val dateMiseAJour: Instant?
) {
    companion object {
        fun fromRecord(variable: VariablecalcultarifRecord) =
                VariableCalculTarif(
                        variable.idcalcultarif,
                        variable.variablename,
                        VariableType.valueOf(variable.variabletype.literal),
                        variable.datecreation.toInstant(),
                        variable.datemiseajour?.toInstant()
                )
    }
}


enum class VariableType(name: String) {
    Numeric("numeric"), Boolean("boolean")
}

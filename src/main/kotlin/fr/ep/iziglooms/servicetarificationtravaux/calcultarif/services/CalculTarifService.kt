package fr.ep.iziglooms.servicetarificationtravaux.calcultarif.services

import arrow.core.getOrElse
import arrow.data.k
import arrow.syntax.option.toOption
import fr.ep.iziglooms.servicetarificationtravaux.calcultarif.domain.dto.ConditionAjoutElement
import fr.ep.iziglooms.servicetarificationtravaux.calcultarif.repositories.CalculTarifRepository
import org.springframework.stereotype.Service

@Service
class CalculTarifService(val repository: CalculTarifRepository) {

    private fun findByAction(action: String) = repository.findByAction(action)

    fun calculerTarif(action: String, variables: Map<String, String>) = findByAction(action).map {
        it.produits.k()
                .filter {
                    validate(it.conditions, variables)
                }
                .map {
                    it.copy(caracteristiques = it.caracteristiques.filter {
                        validate(it.conditions, variables)
                    })
                }
    }

    fun validate(conditions: List<ConditionAjoutElement>, variables: Map<String, String>) = conditions.all { condition ->
        variables[condition.variableName]
                .toOption()
                .map { value ->
                    when (condition.operator) {
                        "GreaterThan" -> value.toDoubleOrNull().toOption().getOrElse { 0.0 } > condition.valueCondition.toDouble()
                        "LesserThan" -> value.toDoubleOrNull().toOption().getOrElse { 0.0 } < condition.valueCondition.toDouble()
                        "Equals" -> value == condition.valueCondition
                        else -> false
                    }
                }
                .getOrElse {
                    false
                }
    }
}

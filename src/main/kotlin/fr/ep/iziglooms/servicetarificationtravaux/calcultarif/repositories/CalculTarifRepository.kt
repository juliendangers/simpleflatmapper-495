package fr.ep.iziglooms.servicetarificationtravaux.calcultarif.repositories

import fr.ep.iziglooms.servicetarificationtravaux.calcultarif.domain.dto.*
import fr.ep.iziglooms.servicetarificationtravaux.persistence.tables.*
import fr.ep.iziglooms.servicetarificationtravaux.persistence.tables.records.*
import fr.ep.iziglooms.servicetarificationtravaux.utils.toOption
import org.jooq.*
import org.simpleflatmapper.jdbc.JdbcMapperFactory
import org.simpleflatmapper.util.TypeReference
import org.springframework.stereotype.Repository

@Repository
class CalculTarifRepository (val dsl: DSLContext) {

    fun findByAction(action: String) = jdbcMapper.stream(
                defaultQueryDSL(dsl, (CALCULTARIF.ACTION.eq(action)))
        )
            .map(resultSetMapper)
            .findFirst()
            .toOption()

    companion object {
        val CALCULTARIF: Calcultarif = Calcultarif.CALCULTARIF
        private val AJOUT_PRODUIT: Ajoutproduit = Ajoutproduit.AJOUTPRODUIT
        private val AJOUT_CARACTERISTIQUE: Ajoutproduitcaracteristique = Ajoutproduitcaracteristique.AJOUTPRODUITCARACTERISTIQUE
        private val CONDITION_AJOUT_PRODUIT: Conditionajoutproduit = Conditionajoutproduit.CONDITIONAJOUTPRODUIT
        private val CONDITION_AJOUT_CARACTERISTIQUE: Conditionajoutproduitcaracteristique = Conditionajoutproduitcaracteristique.CONDITIONAJOUTPRODUITCARACTERISTIQUE

        private val defaultSelect = { dsl: DSLContext ->
            dsl.select()
                    .from(CALCULTARIF)
                    .join(AJOUT_PRODUIT).using(AJOUT_PRODUIT.IDCALCULTARIF)
                    .leftJoin(CONDITION_AJOUT_PRODUIT).using(CONDITION_AJOUT_PRODUIT.IDAJOUTPRODUIT)
                    .leftJoin(AJOUT_CARACTERISTIQUE).using(AJOUT_CARACTERISTIQUE.IDAJOUTPRODUIT)
                    .leftJoin(CONDITION_AJOUT_CARACTERISTIQUE).using(AJOUT_CARACTERISTIQUE.IDAJOUTPRODUITCARACTERISTIQUE)
        }

        val defaultQueryDSL = { dsl: DSLContext, conditions: Condition ->
            defaultSelect(dsl)
                    .where(conditions)
                    .orderBy(CALCULTARIF.IDCALCULTARIF)
                    .fetchResultSet()
        }

        val jdbcMapper = JdbcMapperFactory
                .newInstance()
                .addKeys(CALCULTARIF.IDCALCULTARIF.name,
                        AJOUT_PRODUIT.IDAJOUTPRODUIT.name,
                        CONDITION_AJOUT_PRODUIT.IDCONDITIONAJOUTPRODUIT.name,
                        AJOUT_CARACTERISTIQUE.IDAJOUTPRODUITCARACTERISTIQUE.name,
                        CONDITION_AJOUT_CARACTERISTIQUE.IDCONDITIONAJOUTPRODUITCARACTERISTIQUE.name)
                .newMapper(object : TypeReference<Pair<CalcultarifRecord, List<Triple<AjoutproduitRecord, List<ConditionajoutproduitRecord?>, List<Pair<AjoutproduitcaracteristiqueRecord?, List<ConditionajoutproduitcaracteristiqueRecord?>>>>>>>() {})

        val resultSetMapper = { result: Pair<CalcultarifRecord, List<Triple<AjoutproduitRecord, List<ConditionajoutproduitRecord?>, List<Pair<AjoutproduitcaracteristiqueRecord?, List<ConditionajoutproduitcaracteristiqueRecord?>>>>>> ->
            CalculTarifDto.fromRecord(result.first, result.second.map { produits ->
                AjoutProduitDto.fromRecord(produits.first,
                        produits.second.mapNotNull { it?.let { ConditionAjoutElement.fromRecord(it) } },
                        produits.third.mapNotNull { caracteristiquesAndConditions ->
                            caracteristiquesAndConditions.first?.let {
                                AjoutProduitCaracteristiqueDto.fromRecord(it, caracteristiquesAndConditions.second.mapNotNull { it?.let { ConditionAjoutElement.fromRecord(it) } })
                            }
                        })
            })
        }
    }
}

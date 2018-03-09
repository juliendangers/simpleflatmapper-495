package fr.ep.iziglooms.servicetarificationtravaux.calcultarif.controllers

import fr.ep.iziglooms.servicetarificationtravaux.calcultarif.services.CalculTarifService
import org.slf4j.LoggerFactory
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

@Suppress("IMPLICIT_CAST_TO_ANY")
@RestController
@RequestMapping("/v1")
class CalculTarifController(val service: CalculTarifService) {

    private val logger = LoggerFactory.getLogger(CalculTarifController::class.qualifiedName)

    @PostMapping("/tarif/{action}")
    fun calculTarif(@PathVariable action: String, @RequestBody variables: Map<String, String>): ResponseEntity<Any> =
            service.calculerTarif(action, variables)
                    .fold({
                        ResponseEntity.notFound().build()
                    }, {
                        if (it.isNotEmpty()) {
                            ResponseEntity.ok(it)
                        } else {
                            ResponseEntity.badRequest().build()
                        }
                    })
}
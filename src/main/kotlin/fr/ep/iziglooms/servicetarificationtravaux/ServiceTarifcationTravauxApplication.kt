package fr.ep.iziglooms.servicetarificationtravaux

import org.springframework.boot.SpringApplication
import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.transaction.annotation.EnableTransactionManagement

@SpringBootApplication
@EnableTransactionManagement
class ServiceTarificationTravauxApplication

fun main(args: Array<String>) {
    SpringApplication.run(ServiceTarificationTravauxApplication::class.java, *args)
}

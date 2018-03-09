package fr.ep.iziglooms.servicetarificationtravaux.utils

import arrow.core.Option
import java.util.*

fun <T> Optional<T>.toOption() = Option.fromNullable(this.orElse(null))

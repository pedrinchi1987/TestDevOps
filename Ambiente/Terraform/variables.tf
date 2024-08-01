variable "env" {
  type        = string
  description = "Valor de ambiente"
}

variable "region" {
  type        = string
  description = "Valor de Region"
}

variable "access_key" {
  type        = string
  description = "Valor de clave de Acceso"
}

variable "secret_key" {
  type        = string
  description = "Valor de la llave secreta"
}

variable "habilitar_publica" {
  type        = bool
  description = "Habilitar red publica"
  default     = false
}

variable "cantidad_instancias" {
  type        = number
  description = "Cantidad de Instancias"
  default     = 0
}

variable "cantidad_zonas" {
  type        = number
  description = "Cantidad de Zonas de Disponibilidad"
  default     = 1
}

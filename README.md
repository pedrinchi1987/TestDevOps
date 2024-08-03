# TestDevOps
Prueba Validacion DevOps develop

Para esta Prueba se ha realizado lo siguiente:

1) Construcción de Pipeline de IC (Para generación de Artefacto).
2) Construcción de Pipeline de IC (Para generación Infraestructura).
3) Construcción de Pipeline de DC (Para Despliegue de artecfacto en agente local).

## Herramientas a Usar:

1) Administrador de codigo fuente GitHub.
2) Proyecto Java dado por el solicitante (maven, sprint boot) + Jacoco para cobertura de código.
3) Azure DevOps Service para Construcción de Pipelines.
4) Vagrant para despliegue de Agente Local.
5) Ubuntu para despliegue de Maquinas Virtuales y Shell scripts para configurarlas.
6) Terraform para despliegue de infraestructura en la nube.
7) AWS como nube.
8) SonarCloud para medición de calidad de código estático.
9) Docker para Contenerización (generación).
10) Minikube para despliegue de contenedores como servicio (en agente local).
11) Estado Remotos de Terraform (terraform cloud y S3 de AWS).

## Funcionamiento:

### 1) Pasos Manuales y Requisitos:

Carpeta: Ambiente\Vagrant-Agente

En esta Carpeta se encuentra lo necesario para levantar nuestro entorno local con Vagrant.

### Requisitos:
 a) Instalar Vagrant 
 b) Instalar Virtual Box
 c) Tener los token respectivos para la configuración de:
   I) Terraform Cloud
   II) Agente de Azure
   III) Sonar Cloud
   IV) AWS

Con el comando **vagrant up** aqui levantaremos nuestra máquina virtual que nos servirá de agente para nuestro Azure DevOps Service y para instalar nuestros contenedores en minikube.

![image](https://github.com/user-attachments/assets/853c1fcb-4226-42cb-8d3b-147a27051ef9)

Dentro de la instalación principal la máquina queda lista con:
a) Version de Ubuntu Actualizada, paquetes de sistema necesarios.
b) Descargada la version del agende de Azure (sin embargo el zip **install_agent_azure_linux.tar.gz** es solo dummy, para hacer el ejercicio deberan reemplazar con la de su cuenta).
c) Por Problemas con las credenciales los siguientes comandos hay que ejecutarlos manualmente luego de crear la maquina
  I) Acceder a la maquina y ejecutando un vagrant ssh
  II) Ejecutar el script **.\script\install_containers.sh** que instalará todo lo necesario para el despliegue de los contenedores (entre estos docker, kubectl, minikube)
    * En el mismo script encontraremos una sección con la leyenda **#ESTOS COMANDOS HAY QUE EJECUTARLOS A MANO POSTERIOR A LA EJECUCION DE ESTE SCRIPT**, y podremos ejecutar ese comando manualmente, que es el **minikube start**

![image](https://github.com/user-attachments/assets/b9f6fd02-0a9a-4980-ba70-615ba80a228b)

  III) Terminaremos de configurar el agente con el script **.\script\install_agente.sh**, deberemos acceder a la carpeta **myagent** ya creada en la instalación
    * Ejecutar el comando **./config.sh** y configurar los valores segun las peticiones como son:
    * En el mismo script encontraremos una sección con la leyenda **#ESTOS COMANDOS HAY QUE EJECUTARLOS A MANO POSTERIOR A LA EJECUCION DE ESTE SCRIPT**, con el ejemplo de valores a escribir como son: URL (azure DevOps), Token de Azure, Nombre del Agente (**PRMR** para mi ejemplo).
  IV) Ejecutar el comando **./run.sh**

![image](https://github.com/user-attachments/assets/2b49afff-18bf-4bf1-a0d0-1d4c3997ea8f)

El agente se encuentra configurado y en linea

![image](https://github.com/user-attachments/assets/54193f15-9ae1-4cb9-a42b-7c5b85fbb413)

d) También se penso en este agente ejecutar terraform de forma local con terraform cloud para guardar el estado, para esto necesitamos la configuración del script **.\script\config_login_terraform.sh**, ejecutarlo de manera manual lo que esta dentro del script ya que por diferentes razones solamente asi se crean las de configuraciones de terraform **.terraform.d**

### 2) Pipelines IC

### a) PIPELINE DevsuPrueba-Maven-CI

Tenemos el pipeline de contrucción con los siguientes pasos:

![image](https://github.com/user-attachments/assets/b8f39cd8-f3c1-45c8-8a04-1ad6c184f982)

Este pipeline se encarga de generar el artefacto, ejecución de test y análisis Estático)

Para el correcto funcionamieto de este pipeline necesitamos configurar las variables de Sonar

![image](https://github.com/user-attachments/assets/01e2e95d-0e04-4b49-8562-08f3e7f9ec2d)

### Resultado de este Pipeline
* Objeto Generado
* Pruebas Ejecutadas
* Análisis de Código Estático Realizado
* Publicar DockerFile
* Publicar Yaml Kubernetes para despliegue

### Deseables en esta parte del ejercicio:

* Versionar el artefacto. (Snapshot - Release de acuerdo a la rama y replace de acuerdo a la compilación). (Esto quedo para otro momento)
* Queria realizar una codificación que la ejecución sea automática de acuerdo al commit realizado, para que no se ejecute cuando los cambios se den en otras carpetas que no sea código. (Esto quedo para otro momento)
   
### b) PIPELINE DevsuPrueba-Terraform-CI

![image](https://github.com/user-attachments/assets/9b16f694-a1be-480c-8862-139f24392cc8)

Para que funcione este pipeline necesitamos configurar las variables con los valores de los requisitos. En este pipeline se ha configurado la tarea de apply y destroy para que el ejercicio no deje infraestructura creada, ademas este pipeline usa el estado guardado en un S3 de amazon, por las tareas usadas en Azure DevOps

![image](https://github.com/user-attachments/assets/23f9cad7-d1dc-4abf-bac9-23924eb886af)

Nota: para este ejercicio debe estar creado el s3

![image](https://github.com/user-attachments/assets/be8febb9-d2f6-47bc-a677-eecc05e0904b)

### Resultado de este Pipeline
* Infraestructura de AWS desplegada por IAC con estado remoto en AWS S3
  
### Deseables en esta parte del ejercicio:

* Queria realizar una codificación para la variable **isDestroy** para que sea ella quien decida si ibamos a hacer un apply o destroy. (Esto quedo para otro momento)
* Queria realizar una codificación que la ejecución sea automática de acuerdo al commit realizado. (Esto quedo para otro momento)

### c) PIPELINE PruebaTerraformCloudStatus

Se hizo una prueba para la ejecución del código terraform con el estado remoto de terraform cloud

![image](https://github.com/user-attachments/assets/33e5791f-394a-4f88-9f3d-dff8d97a7784)

![image](https://github.com/user-attachments/assets/fa436edf-fec5-4a77-9163-da686718f875)

### Resultado de este Pipeline
* Prueba de configuración con el estado de terraform en terraform cloud

### 4) Pipelines CD

### a) PIPELINE DevsuPrueba-CD

Tiene como disparador el resultado del pipeline IC **IPELINE DevsuPrueba-Maven-CI**

![image](https://github.com/user-attachments/assets/630480b0-fcc2-4762-a1f5-50c8459457da)

### * Paso 1

Publicar en docker hub, el objeto generado bajo el tag respectivo

![image](https://github.com/user-attachments/assets/d4f869d5-802e-4d1a-9985-c52be003afe2)

### * Paso 2

Publicar o Desplegar el contenedor de acuerdo a archivo generado y usando la publicación del objeto en docker en el agente local.

![image](https://github.com/user-attachments/assets/e2e7f9ad-22b0-442f-9a23-05a38716d17d)

### 5) Ejecuciones



![image](https://github.com/user-attachments/assets/50b42c0e-9824-434e-9669-4f7b16eb7a00)

![image](https://github.com/user-attachments/assets/ed3181ee-be86-459e-8327-f22964b4b280)


![image](https://github.com/user-attachments/assets/98f01690-eda6-4365-bee0-15627e0197d9)

![image](https://github.com/user-attachments/assets/467199b7-2670-4b51-8cca-f27a52a09121)



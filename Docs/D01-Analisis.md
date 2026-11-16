# Documento de análisis del problema

## Sistema de Gestión de Órdenes de Reparación de un Taller Automotriz

**Curso:** Base de Datos 1\
**Proyecto:** Sistema de Gestión de Órdenes de Reparación de un Taller
Automotriz\
**Estudiante:** Lutwing Yussef Martinez Vasquez \
**Fecha:** 14/11/2026

------------------------------------------------------------------------

## 1. Introducción

El presente documento analiza la situación actual de un taller
automotriz y define los elementos de información que debe contemplar una
solución basada en una base de datos relacional. El propósito es
establecer las entidades, atributos, claves, relaciones y reglas
principales que permitirán administrar los clientes, vehículos, órdenes
de reparación, servicios, repuestos y mecánicos.

El análisis se basa en el planteamiento proporcionado para el proyecto.
Las decisiones de diseño que requieren una precisión adicional se
indican como supuestos para que puedan validarse antes de elaborar el
diagrama entidad-relación y la implementación.

## 2. Descripción del problema

El taller ofrece servicios de mantenimiento y reparación de vehículos,
entre ellos cambios de aceite, revisión de frenos, alineación,
diagnóstico del motor, reparación del sistema eléctrico y sustitución de
componentes.

Actualmente, la información de clientes, vehículos, mecánicos, servicios
y repuestos se administra mediante registros independientes. Esta forma
de trabajo ocasiona los siguientes problemas:

-   Duplicación de datos de clientes, vehículos, mecánicos, servicios y
    repuestos.
-   Dificultad para calcular el costo total de una reparación.
-   Dificultad para consultar el historial de reparaciones de cada
    vehículo.
-   Falta de una estructura adecuada para registrar varios servicios y
    repuestos en una misma orden.
-   Dificultad para identificar a todos los mecánicos que participaron
    en una reparación y las actividades que realizaron.
-   Riesgo de alterar los costos históricos cuando cambia el precio
    actual de un repuesto.
-   Dificultad para consultar el estado de las órdenes y generar
    información sobre los servicios, ingresos y productividad del
    taller.

Por lo anterior, se necesita una base de datos relacional que centralice
la información y permita registrar y consultar las operaciones del
taller de manera consistente.

## 3. Objetivos del sistema

### 3.1 Objetivo general

Diseñar una base de datos relacional que permita administrar la
información de clientes, vehículos, órdenes de reparación, servicios,
repuestos y mecánicos, conservando el historial de las operaciones y
facilitando la consulta de los datos del taller.

### 3.2 Objetivos específicos

1.  Registrar los clientes y los vehículos asociados a cada uno.
2.  Registrar las órdenes de reparación, incluyendo la fecha de
    recepción, el problema reportado, el estado y el mecánico
    responsable.
3.  Permitir que una orden incluya varios servicios y varios repuestos.
4.  Registrar la cantidad y el precio aplicado de cada repuesto
    utilizado en una orden.
5.  Registrar la participación de varios mecánicos en una misma
    reparación, incluyendo los trabajos realizados y el tiempo dedicado
    cuando corresponda.
6.  Conservar los precios históricos aplicados en las órdenes, aunque
    los precios de catálogo cambien posteriormente.
7.  Consultar el historial de reparaciones de los vehículos y generar
    información sobre costos, servicios e intervención de los mecánicos.

## 4. Alcance del sistema

El sistema contempla la administración de los siguientes elementos:

-   **Clientes:** datos de las personas que solicitan los servicios del
    taller.
-   **Vehículos:** información de los vehículos registrados y su
    relación con un cliente.
-   **Órdenes de reparación:** registro de cada ingreso de un vehículo
    al taller, su problema reportado, fechas, estado y responsable.
-   **Servicios:** catálogo de los trabajos que ofrece el taller.
-   **Repuestos:** catálogo de los repuestos disponibles o utilizados en
    las reparaciones.
-   **Mecánicos:** información del personal técnico que puede participar
    en las reparaciones.
-   **Detalle de servicios por orden:** registro de los servicios
    incluidos en cada orden y del precio aplicado.
-   **Detalle de repuestos por orden:** registro de los repuestos
    utilizados, su cantidad y precio aplicado.
-   **Participación de mecánicos:** registro de los mecánicos que
    intervienen en cada orden, las actividades que realizan y el tiempo
    dedicado, si se registra.

El sistema también deberá permitir consultas relacionadas con el resumen
de órdenes, historial de vehículos, participación de mecánicos,
servicios más solicitados, consumo de repuestos e ingresos generados.

## 5. Identificación de entidades y atributos

A continuación se propone una estructura inicial de entidades. Los
nombres de atributos pueden ajustarse al motor de base de datos y a las
convenciones utilizadas en la implementación.

### 5.1 Cliente

Almacena la información de las personas que solicitan los servicios del
taller.

  Atributo     Descripción                       Clave / condición
  ------------ --------------------------------- ----------------------
  cliente_id   Identificador único del cliente   PK
  nombre       Nombre del cliente                Obligatorio
  telefono     Número de contacto                Según disponibilidad
  correo       Correo electrónico                Opcional

### 5.2 Vehículo

Almacena los vehículos registrados en el taller y el cliente al que
están asociados.

  -----------------------------------------------------------------------
  Atributo                Descripción             Clave / condición
  ----------------------- ----------------------- -----------------------
  vehiculo_id             Identificador único del PK
                          vehículo                

  cliente_id              Cliente propietario o   FK → Cliente.cliente_id
                          responsable del         
                          vehículo                

  placa                   Placa del vehículo      Obligatorio; UNIQUE

  marca                   Marca del vehículo      Obligatorio

  modelo                  Modelo del vehículo     Opcional

  anio                    Año del vehículo        Opcional
  -----------------------------------------------------------------------

### 5.3 Mecánico

Almacena la información del personal técnico que puede participar en las
reparaciones.

  Atributo       Descripción                         Clave / condición
  -------------- ----------------------------------- -------------------
  mecanico_id    Identificador único del mecánico    PK
  nombre         Nombre del mecánico                 Obligatorio
  telefono       Número de contacto                  Opcional
  especialidad   Área de especialización             Opcional
  estado         Indica si el mecánico está activo   Obligatorio

### 5.4 Orden de reparación

Representa el ingreso de un vehículo al taller para realizar una
reparación o mantenimiento.

  -------------------------------------------------------------------------
  Atributo                  Descripción             Clave / condición
  ------------------------- ----------------------- -----------------------
  orden_id                  Identificador único de  PK
                            la orden                

  vehiculo_id               Vehículo relacionado    FK →
                            con la orden            Vehiculo.vehiculo_id

  mecanico_responsable_id   Mecánico responsable de FK →
                            supervisar el trabajo   Mecanico.mecanico_id

  fecha_recepcion           Fecha y hora en que se  Obligatorio
                            recibe el vehículo      

  problema_reportado        Descripción del         Obligatorio
                            problema indicado por   
                            el cliente              

  estado                    Estado actual de la     Obligatorio
                            orden                   

  fecha_entrega             Fecha y hora de entrega Opcional hasta
                            del vehículo            completar la entrega
  -------------------------------------------------------------------------

Los estados contemplados en el planteamiento incluyen: **abierta**, **en
proceso**, **finalizada** y **entregada**. La implementación deberá
controlar que solo se utilicen estados válidos.

### 5.5 Servicio

Contiene el catálogo de servicios que ofrece el taller.

  Atributo        Descripción                        Clave / condición
  --------------- ---------------------------------- -------------------
  servicio_id     Identificador único del servicio   PK
  nombre          Nombre del servicio                Obligatorio
  descripcion     Descripción del trabajo            Opcional
  precio_actual   Precio vigente de referencia       Obligatorio

### 5.6 Repuesto

Contiene el catálogo de repuestos que pueden utilizarse en las
reparaciones.

  Atributo        Descripción                        Clave / condición
  --------------- ---------------------------------- -------------------
  repuesto_id     Identificador único del repuesto   PK
  nombre          Nombre del repuesto                Obligatorio
  descripcion     Descripción del repuesto           Opcional
  precio_actual   Precio vigente de referencia       Obligatorio

### 5.7 Detalle de servicio por orden

Resuelve la relación de muchos a muchos entre órdenes y servicios. Cada
registro representa un servicio incluido en una orden.

  --------------------------------------------------------------------------
  Atributo                Descripción             Clave / condición
  ----------------------- ----------------------- --------------------------
  orden_servicio_id       Identificador del       PK
                          detalle                 

  orden_id                Orden a la que          FK →
                          pertenece el detalle    OrdenReparacion.orden_id

  servicio_id             Servicio realizado      FK → Servicio.servicio_id

  cantidad                Número de unidades o    Obligatorio
                          veces que se registra   
                          el servicio             

  precio_aplicado         Precio unitario cobrado Obligatorio
                          en esa orden            
  --------------------------------------------------------------------------

Se almacena el precio aplicado en el detalle para conservar el importe
histórico, aunque el precio vigente del catálogo de servicios cambie
posteriormente. Si el taller decide que cada servicio solo puede
aparecer una vez por orden, también podría utilizarse una clave primaria
compuesta por `orden_id` y `servicio_id`; el identificador propio del
detalle permite representar varias líneas del mismo servicio cuando sea
necesario.

### 5.8 Detalle de repuesto por orden

Resuelve la relación de muchos a muchos entre órdenes y repuestos. Cada
registro representa un repuesto utilizado en una orden.

  --------------------------------------------------------------------------
  Atributo                Descripción             Clave / condición
  ----------------------- ----------------------- --------------------------
  orden_repuesto_id       Identificador del       PK
                          detalle                 

  orden_id                Orden a la que          FK →
                          pertenece el detalle    OrdenReparacion.orden_id

  repuesto_id             Repuesto utilizado      FK → Repuesto.repuesto_id

  cantidad                Cantidad utilizada      Obligatorio; mayor que
                                                  cero

  precio_aplicado         Precio unitario del     Obligatorio
                          repuesto al momento de  
                          la reparación           
  --------------------------------------------------------------------------

El atributo `precio_aplicado` es indispensable para conservar el costo
histórico. Un cambio posterior en `Repuesto.precio_actual` no debe
modificar el valor registrado en una orden anterior.

### 5.9 Participación de mecánicos

Resuelve la relación de muchos a muchos entre órdenes y mecánicos. Cada
registro identifica la intervención de un mecánico en una orden.

  --------------------------------------------------------------------------
  Atributo                Descripción             Clave / condición
  ----------------------- ----------------------- --------------------------
  participacion_id        Identificador de la     PK
                          participación           

  orden_id                Orden en la que         FK →
                          participa el mecánico   OrdenReparacion.orden_id

  mecanico_id             Mecánico que participa  FK → Mecanico.mecanico_id

  trabajo_realizado       Descripción de las      Obligatorio
                          actividades realizadas  

  horas_trabajadas        Tiempo dedicado a la    Opcional; no negativo
                          orden                   
  --------------------------------------------------------------------------

Esta entidad permite registrar varios mecánicos en una misma orden y que
un mecánico participe en distintas órdenes. También proporciona
información para consultas de productividad.

## 6. Relaciones y cardinalidades

Las relaciones propuestas son las siguientes:

  Entidad de origen     Relación            Entidad de destino              Cardinalidad
  --------------------- ------------------- ------------------------------- --------------
  Cliente               Tiene / registra    Vehículo                        1:N
  Vehículo              Puede tener         Orden de reparación             1:N
  Mecánico              Es responsable de   Orden de reparación             1:N
  Orden de reparación   Incluye             Detalle de servicio por orden   1:N
  Servicio              Aparece en          Detalle de servicio por orden   1:N
  Orden de reparación   Contiene            Detalle de repuesto por orden   1:N
  Repuesto              Aparece en          Detalle de repuesto por orden   1:N
  Orden de reparación   Registra            Participación de mecánicos      1:N
  Mecánico              Registra            Participación de mecánicos      1:N

De estas relaciones se derivan las siguientes relaciones de muchos a
muchos:

-   **Orden de reparación -- Servicio:** una orden puede incluir varios
    servicios y un servicio puede aparecer en distintas órdenes. Se
    resuelve mediante `DetalleServicioOrden`.
-   **Orden de reparación -- Repuesto:** una orden puede utilizar varios
    repuestos y un repuesto puede utilizarse en distintas órdenes. Se
    resuelve mediante `DetalleRepuestoOrden`.
-   **Orden de reparación -- Mecánico:** una orden puede contar con
    varios mecánicos y un mecánico puede participar en distintas
    órdenes. Se resuelve mediante `ParticipacionMecanico`.

## 7. Reglas de negocio identificadas

1.  Cada vehículo debe estar asociado a un cliente registrado.
2.  Cada orden de reparación debe corresponder a un vehículo existente.
3.  Cada orden debe registrar su fecha de recepción, el problema
    reportado y un estado válido.
4.  Cada orden debe tener un mecánico responsable de supervisar el
    trabajo.
5.  Una orden puede contener uno o varios servicios.
6.  Una orden puede contener uno o varios repuestos, pero también puede
    existir una orden sin repuestos utilizados.
7.  Los servicios y repuestos registrados en los detalles deben existir
    en sus respectivos catálogos.
8.  La cantidad de repuestos utilizada debe ser mayor que cero.
9.  El precio aplicado a un repuesto debe conservarse en el detalle de
    la orden y no depender del precio actual del catálogo.
10. Una orden puede tener la participación de varios mecánicos.
11. La participación de cada mecánico debe permitir identificar el
    trabajo realizado y, cuando corresponda, el tiempo dedicado.
12. La fecha de entrega debe permanecer vacía mientras la orden no haya
    sido entregada. Cuando exista, no debe ser anterior a la fecha de
    recepción.
13. Los registros históricos deben conservarse para permitir consultar
    reparaciones anteriores.

## 8. Justificación de las principales decisiones de diseño

### 8.1 Separación de entidades

Los clientes, vehículos, mecánicos, servicios, repuestos y órdenes se
almacenan en entidades independientes para evitar repetir sus datos en
cada registro de reparación. Esto facilita el mantenimiento de la
información y reduce inconsistencias.

### 8.2 Uso de tablas de detalle

Las tablas de detalle permiten que una orden contenga múltiples
servicios y repuestos sin crear columnas repetidas ni limitar la
cantidad de elementos que pueden registrarse. También permiten almacenar
atributos propios de cada utilización, como cantidad y precio aplicado.

### 8.3 Registro de la participación de mecánicos

La entidad `ParticipacionMecanico` permite representar correctamente que
varios mecánicos pueden trabajar en una misma orden y que cada mecánico
puede intervenir en diferentes órdenes. Además, permite registrar las
tareas y las horas trabajadas.

### 8.4 Conservación de precios históricos

El catálogo de repuestos mantiene el precio actual, mientras que el
detalle de repuestos almacena el precio aplicado en el momento de la
reparación. Así, las modificaciones futuras del catálogo no alteran los
costos históricos. Se propone el mismo criterio para los servicios
mediante `precio_aplicado` en el detalle de servicios.

### 8.5 Identificadores y claves foráneas

Cada entidad principal cuenta con una clave primaria que identifica sus
registros. Las claves foráneas permiten relacionar los registros y
evitar que una orden, detalle o participación haga referencia a
entidades inexistentes.

## 9. Supuestos y decisiones pendientes de validación

Para completar el modelo se adoptan provisionalmente los siguientes
supuestos:

-   El cliente registrado en un vehículo representa a su propietario o
    responsable actual. El planteamiento no especifica si debe
    conservarse el historial de propietarios anteriores.
-   El mecánico responsable de una orden pertenece al catálogo de
    mecánicos y puede, además, aparecer en la tabla de participación.
-   Los precios se almacenan como valores monetarios en los detalles de
    la orden para conservar el importe histórico.
-   Una orden puede existir sin repuestos; por tanto, no se debe exigir
    que toda orden tenga registros en el detalle de repuestos.
-   El tiempo trabajado por cada mecánico puede ser opcional, porque el
    planteamiento indica que debe registrarse cuando corresponda.
-   El costo de una orden se obtiene a partir de los importes de sus
    detalles de servicios y repuestos. No se propone almacenar un total
    manual que pueda quedar desactualizado.

Estos supuestos deberán confirmarse durante la elaboración del diagrama
entidad-relación y la implementación de la base de datos.

## 10. Resultado esperado

Con el modelo propuesto, el taller podrá centralizar sus registros,
administrar órdenes con varios servicios y repuestos, identificar a los
mecánicos participantes y conservar los precios históricos de cada
reparación. La estructura también permitirá generar consultas sobre el
historial de los vehículos, los servicios más solicitados, el consumo de
repuestos, los ingresos y la participación del personal técnico.



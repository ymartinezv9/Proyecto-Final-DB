# Explicación de la normalización

## Sistema de Gestión de Órdenes de Reparación de un Taller Automotriz

## 1. Introducción

La normalización es un proceso que permite organizar la información de una base de datos para reducir la redundancia, evitar anomalías y mantener la integridad de los datos.

En el caso del taller automotriz, actualmente se utiliza un registro consolidado que almacena información de las órdenes, clientes, vehículos, mecánicos, servicios y repuestos en una misma estructura.

Este diseño provoca que algunos datos se repitan en diferentes registros y que las modificaciones puedan generar inconsistencias. Por esta razón, se analizará la estructura original y se aplicarán las tres primeras formas normales (1FN, 2FN y 3FN).

El objetivo es obtener una estructura relacional que permita administrar correctamente las órdenes de reparación, consultar el historial de los vehículos y conservar los precios aplicados en reparaciones anteriores.

## 2. Análisis de la estructura original

El registro consolidado utilizado por el taller contiene los siguientes atributos:

| Atributo | Descripción |
|---|---|
| CodOrden | Código que identifica la orden de reparación. |
| FechaOrden | Fecha en que se registra la orden. |
| CodCliente | Código que identifica al cliente. |
| NombreCliente | Nombre del cliente. |
| Placa | Placa del vehículo. |
| MarcaVehiculo | Marca del vehículo. |
| CodMecanico | Código del mecánico responsable. |
| NombreMecanico | Nombre del mecánico. |
| CodServicio | Código del servicio realizado. |
| NombreServicio | Descripción del servicio. |
| CodRepuesto | Código del repuesto utilizado. |
| NombreRepuesto | Descripción del repuesto. |
| Cantidad | Cantidad de repuestos utilizados. |
| PrecioRepuesto | Precio aplicado al repuesto. |

En el registro original se observa que una misma orden puede aparecer en varias filas cuando contiene diferentes repuestos. Por ejemplo, la orden O001 aparece dos veces porque utiliza un filtro de aceite y aceite de motor.

También se observa que la orden O003 contiene información de un servicio, pero no utiliza repuestos. En este caso, los campos correspondientes al repuesto aparecen con valores NULL.

Esta organización mezcla información que pertenece a diferentes elementos del sistema, lo que genera redundancia y dificulta el mantenimiento de los datos.

## 3. Problemas de redundancia y anomalías

### 3.1. Redundancia de información

La redundancia ocurre cuando un mismo dato se almacena repetidamente en diferentes registros.

En el registro original se identifican los siguientes casos:

- Los datos del cliente se repiten cuando este registra más de una orden.
- La información del vehículo se repite cada vez que aparece una nueva orden para ese vehículo.
- Los datos del mecánico se repiten en todas las filas correspondientes a sus órdenes.
- Los nombres de servicios y repuestos se repiten cuando estos aparecen en diferentes órdenes.

Esta repetición aumenta el espacio utilizado y puede provocar inconsistencias si los datos no se actualizan correctamente.

### 3.2. Anomalía de inserción

Una anomalía de inserción ocurre cuando no es posible registrar determinada información sin introducir datos adicionales que todavía no existen o que no corresponden.

Por ejemplo, si el taller desea registrar un nuevo cliente, pero este todavía no ha solicitado una reparación, el registro consolidado no ofrece una forma adecuada de almacenar sus datos de manera independiente.

De igual manera, no sería conveniente registrar un nuevo servicio o repuesto si todavía no ha sido utilizado en una orden.

### 3.3. Anomalía de actualización

Una anomalía de actualización ocurre cuando un mismo dato se encuentra almacenado en diferentes registros y es necesario modificar todas sus apariciones.

Por ejemplo, si cambia el nombre de un cliente, sería necesario modificar todas las filas donde aparece su código. Si alguna fila no se actualiza, la base de datos podría mostrar información diferente para el mismo cliente.

El mismo problema puede presentarse con los nombres de los mecánicos, las marcas de los vehículos y las descripciones de los servicios y repuestos.

### 3.4. Anomalía de eliminación

Una anomalía de eliminación ocurre cuando al eliminar un registro se pierde información adicional que debería conservarse.

Por ejemplo, si se elimina la única fila donde aparece un servicio, también podría perderse la información que describe dicho servicio.

De igual manera, si se elimina la única orden asociada a un cliente, podrían perderse sus datos personales, aunque estos deberían poder mantenerse independientemente de sus reparaciones.

## 4. Clave primaria propuesta para el registro original

Para identificar de manera única cada fila del registro original se propone utilizar una clave compuesta formada por:

**(CodOrden, NumeroLinea)**

El atributo `CodOrden` identifica la orden de reparación, mientras que `NumeroLinea` identifica cada renglón dentro de esa orden.

Por ejemplo:

| CodOrden | NumeroLinea | CodRepuesto |
|---|---:|---|
| O001 | 1 | R01 |
| O001 | 2 | R02 |
| O002 | 1 | R03 |
| O003 | 1 | NULL |

Esta combinación permite distinguir los diferentes renglones de una misma orden, incluso cuando existen varios repuestos o servicios asociados.

En el caso de una orden que no utiliza repuestos, como O003, puede existir un renglón para representar el servicio sin necesidad de inventar un código de repuesto.

La clave compuesta propuesta permite identificar cada registro sin depender de que todos los campos tengan un valor. En el modelo definitivo, los detalles de servicios y repuestos se almacenarán en tablas independientes, por lo que ya no será necesario representar los repuestos inexistentes mediante valores NULL.

## 5. Primera Forma Normal (1FN)

Una tabla cumple con la primera forma normal cuando:

- Cada columna contiene valores atómicos, es decir, un solo valor por celda.
- No existen grupos repetitivos dentro de una misma columna.
- Cada registro puede identificarse de manera única mediante una clave primaria.

En el registro original, los datos se encuentran distribuidos en filas individuales. Por ejemplo, los repuestos utilizados en la orden O001 aparecen en dos registros diferentes, en lugar de almacenarse como una lista dentro de una misma celda.

Por lo tanto, la información puede organizarse para cumplir con la primera forma normal utilizando la clave compuesta `(CodOrden, NumeroLinea)`.

Es importante mencionar que la presencia de valores NULL en los campos de repuestos de una orden sin repuestos no representa, por sí sola, una violación de la primera forma normal. Sin embargo, evidencia que la estructura está mezclando información de servicios y repuestos que puede separarse de una mejor manera.

**Resultado:** se establece una identificación única para cada fila y se mantienen los valores individuales en sus respectivas columnas.

## 6. Identificación de dependencias funcionales

Una dependencia funcional representa la relación entre atributos, donde un atributo o conjunto de atributos determina el valor de otro atributo.

A partir de la información del taller se identifican las siguientes dependencias:

| Dependencia funcional | Explicación |
|---|---|
| CodOrden → FechaOrden | Una orden determina su fecha de registro. |
| CodOrden → CodCliente | Una orden corresponde a un cliente. |
| CodOrden → Placa | Una orden está asociada a un vehículo. |
| CodOrden → CodMecanico | Una orden tiene un mecánico responsable. |
| CodCliente → NombreCliente | El código identifica al cliente y permite conocer su nombre. |
| Placa → MarcaVehiculo | La placa identifica al vehículo y permite conocer su marca. |
| CodMecanico → NombreMecanico | El código identifica al mecánico y permite conocer su nombre. |
| CodServicio → NombreServicio | El código identifica el servicio y su descripción. |
| CodRepuesto → NombreRepuesto | El código identifica el repuesto y su descripción. |

Para los detalles de una orden también se considera que:

- La cantidad depende del repuesto incluido en una orden.
- El precio aplicado depende del repuesto y de la operación en la que se utilizó.

Por esta razón, no se debe considerar que `CodRepuesto → PrecioRepuesto` sea una dependencia funcional válida para todos los registros históricos. El precio de un repuesto puede cambiar con el tiempo y el precio registrado en una orden debe conservar el valor aplicado durante esa reparación.

## 7. Segunda Forma Normal (2FN)

Una tabla cumple con la segunda forma normal cuando:

- Cumple previamente con la primera forma normal.
- Todos los atributos que no forman parte de una clave dependen de la clave completa y no solamente de una parte de una clave compuesta.

En el registro original se utiliza la clave compuesta `(CodOrden, NumeroLinea)`.

Sin embargo, existen atributos que dependen únicamente de `CodOrden`, que representa solamente una parte de la clave compuesta.

Por ejemplo:

`CodOrden → FechaOrden, CodCliente, Placa, CodMecanico`

Esto significa que la fecha de la orden, el cliente, el vehículo y el mecánico responsable se repiten en todos los renglones de una misma orden, aunque no dependen del número de línea.

Para eliminar esta dependencia parcial se propone separar la información de las órdenes y los detalles asociados.

### 7.1. Descomposición para alcanzar la 2FN

Se propone la siguiente estructura:

**Cliente**

| Atributo | Descripción |
|---|---|
| CodCliente (PK) | Identificador del cliente. |
| NombreCliente | Nombre del cliente. |

**Vehiculo**

| Atributo | Descripción |
|---|---|
| Placa (PK) | Identificador del vehículo. |
| CodCliente (FK) | Cliente asociado al vehículo. |
| MarcaVehiculo | Marca del vehículo. |

**Mecanico**

| Atributo | Descripción |
|---|---|
| CodMecanico (PK) | Identificador del mecánico. |
| NombreMecanico | Nombre del mecánico. |

**OrdenReparacion**

| Atributo | Descripción |
|---|---|
| CodOrden (PK) | Identificador de la orden. |
| FechaOrden | Fecha de registro. |
| Placa (FK) | Vehículo asociado. |
| CodMecanico (FK) | Mecánico responsable. |

**Servicio**

| Atributo | Descripción |
|---|---|
| CodServicio (PK) | Identificador del servicio. |
| NombreServicio | Nombre del servicio. |

**Repuesto**

| Atributo | Descripción |
|---|---|
| CodRepuesto (PK) | Identificador del repuesto. |
| NombreRepuesto | Nombre del repuesto. |

**DetalleServicioOrden**

| Atributo | Descripción |
|---|---|
| IdDetalleServicio (PK) | Identificador del detalle. |
| CodOrden (FK) | Orden a la que pertenece. |
| CodServicio (FK) | Servicio realizado. |

**DetalleRepuestoOrden**

| Atributo | Descripción |
|---|---|
| IdDetalleRepuesto (PK) | Identificador del detalle. |
| CodOrden (FK) | Orden a la que pertenece. |
| CodRepuesto (FK) | Repuesto utilizado. |
| Cantidad | Cantidad utilizada. |
| PrecioAplicado | Precio del repuesto al momento de la reparación. |

Con esta separación, los datos generales de una orden se almacenan una sola vez y los servicios y repuestos se registran en sus respectivas tablas de detalle.

Además, una orden que no utilice repuestos simplemente no tendrá registros asociados en `DetalleRepuestoOrden`. Esto evita almacenar valores NULL innecesarios en los campos relacionados con repuestos.

**Resultado:** se eliminan las dependencias parciales identificadas y se reduce la repetición de información correspondiente a una misma orden.

## 8. Tercera Forma Normal (3FN)

Una tabla cumple con la tercera forma normal cuando:

- Cumple previamente con la segunda forma normal.
- No existen dependencias transitivas entre atributos que no forman parte de una clave.

Una dependencia transitiva ocurre cuando un atributo depende de otro atributo que, a su vez, depende de la clave primaria.

En el registro original se identifican los siguientes ejemplos:

- `CodOrden → CodCliente → NombreCliente`
- `CodOrden → CodMecanico → NombreMecanico`
- `CodOrden → Placa → MarcaVehiculo`
- `CodOrden → CodServicio → NombreServicio`
- `CodOrden → CodRepuesto → NombreRepuesto`

Esto significa que algunos datos descriptivos dependen indirectamente de la orden, porque realmente describen a otras entidades.

Para eliminar estas dependencias, la información de clientes, vehículos, mecánicos, servicios y repuestos se almacena en tablas independientes.

### 8.1. Estructura final propuesta en 3FN

La estructura final de la base de datos queda organizada de la siguiente manera:

**1. Cliente**

| Atributo | Tipo de clave |
|---|---|
| idCliente | PK |
| nombre | |
| telefono | |
| correo | |

Almacena la información personal de los clientes.

**2. Vehiculo**

| Atributo | Tipo de clave |
|---|---|
| idVehiculo | PK |
| idCliente | FK |
| placa | |
| marca | |
| modelo | |
| anio | |

Almacena la información de los vehículos y permite relacionarlos con sus propietarios.

**3. Mecanico**

| Atributo | Tipo de clave |
|---|---|
| idMecanico | PK |
| nombre | |
| telefono | |
| especialidad | |
| estado | |

Almacena la información de los mecánicos que trabajan en el taller.

**4. OrdenReparacion**

| Atributo | Tipo de clave |
|---|---|
| idOrden | PK |
| idVehiculo | FK |
| idMecanicoResponsable | FK |
| fecha_recepcion | |
| problema_reportado | |
| estado | |
| fecha_entrega | |

Almacena la información general de cada orden de reparación.

**5. Servicio**

| Atributo | Tipo de clave |
|---|---|
| idServicio | PK |
| nombre | |
| descripcion | |
| precio_actual | |

Almacena el catálogo de servicios que ofrece el taller.

**6. Repuesto**

| Atributo | Tipo de clave |
|---|---|
| idRepuesto | PK |
| nombre | |
| descripcion | |
| precio_actual | |

Almacena el catálogo de repuestos disponibles.

**7. DetalleServicioOrden**

| Atributo | Tipo de clave |
|---|---|
| idOrdenServicio | PK |
| idOrden | FK |
| idServicio | FK |
| cantidad | |
| precio_aplicado | |

Permite registrar varios servicios dentro de una misma orden y conservar el precio aplicado en el momento de la reparación.

**8. DetalleRepuestoOrden**

| Atributo | Tipo de clave |
|---|---|
| idOrdenRepuesto | PK |
| idOrden | FK |
| idRepuesto | FK |
| cantidad | |
| precio_aplicado | |

Permite registrar los diferentes repuestos utilizados en una orden, incluyendo su cantidad y precio aplicado.

**9. ParticipacionMecanico**

| Atributo | Tipo de clave |
|---|---|
| idParticipacion | PK |
| idOrden | FK |
| idMecanico | FK |
| trabajo_realizado | |
| horas_trabajadas | |

Permite registrar la participación de varios mecánicos en una misma reparación, especificando el trabajo realizado y las horas dedicadas.

### 8.2. Eliminación de dependencias transitivas

La estructura propuesta elimina las dependencias transitivas al separar los datos descriptivos de cada entidad.

Por ejemplo:

- El nombre del cliente se almacena únicamente en la tabla `Cliente`.
- El nombre del mecánico se almacena únicamente en la tabla `Mecanico`.
- La marca y modelo del vehículo se almacenan en `Vehiculo`.
- El nombre del servicio se almacena en `Servicio`.
- El nombre del repuesto se almacena en `Repuesto`.

Las órdenes utilizan claves foráneas para relacionarse con estas entidades, evitando repetir información descriptiva.

**Resultado:** la información queda organizada en tablas que representan entidades independientes y sus relaciones, reduciendo la redundancia y facilitando el mantenimiento de los datos.

## 9. Conservación de precios históricos

Un requisito importante del proyecto es que los cambios en los precios actuales de los repuestos no modifiquen los costos de reparaciones anteriores.

Para cumplir con este requisito se utilizan dos atributos diferentes:

- `precio_actual`: almacena el precio vigente en el catálogo del repuesto.
- `precio_aplicado`: almacena el precio que se utilizó en una orden específica.

Por ejemplo, si un repuesto tiene un precio actual de Q75.00 y posteriormente aumenta a Q85.00, las órdenes anteriores deben conservar el precio de Q75.00.

La tabla `DetalleRepuestoOrden` mantiene el precio aplicado en cada operación, mientras que la tabla `Repuesto` conserva el precio actual del catálogo.

De esta manera, los costos históricos permanecen correctos y se pueden consultar las reparaciones anteriores sin que los cambios futuros alteren sus valores.

El mismo criterio se aplica a los servicios mediante el atributo `precio_aplicado` de `DetalleServicioOrden`.

## 10. Resumen del proceso de normalización

| Forma normal | Aplicación en el proyecto | Resultado |
|---|---|---|
| Primera forma normal (1FN) | Se identifican los registros mediante una clave única y se mantienen valores individuales en cada columna. | Se evita almacenar listas o grupos de valores dentro de una misma celda. |
| Segunda forma normal (2FN) | Se separan los datos generales de las órdenes de los detalles de servicios y repuestos. | Se eliminan las dependencias parciales de los datos de una orden. |
| Tercera forma normal (3FN) | Se separan clientes, vehículos, mecánicos, servicios y repuestos en tablas independientes. | Se eliminan las dependencias transitivas y se reduce la redundancia. |

## 11. Conclusión

El proceso de normalización permitió transformar el registro consolidado del taller automotriz en una estructura relacional organizada, reduciendo la duplicación de información y evitando anomalías de inserción, actualización y eliminación.

Mediante la primera forma normal se estableció una identificación única para cada registro y se organizaron los valores de manera individual.

Con la segunda forma normal se separaron los datos generales de las órdenes de los detalles correspondientes a los servicios y repuestos utilizados.

Finalmente, mediante la tercera forma normal se distribuyó la información en tablas independientes para clientes, vehículos, mecánicos, órdenes, servicios y repuestos, utilizando claves primarias y foráneas para establecer sus relaciones.

La estructura resultante permite registrar múltiples servicios y repuestos en una misma orden, controlar la participación de varios mecánicos y conservar los precios históricos de las reparaciones.

De esta manera, la base de datos proporciona una organización más consistente, facilita las consultas y permite administrar de forma adecuada la información del taller automotriz.
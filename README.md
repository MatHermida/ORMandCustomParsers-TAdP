# Repositorio de Proyectos: TADP - Grupo Grupal

Este repositorio contiene dos proyectos independientes, desarrollados como parte del curso de Técnicas Avanzadas de Programación. Cada proyecto aborda una temática diferente y está desarrollado utilizando tecnologías y paradigmas particulares. A continuación, se describen ambos proyectos y las tecnologías involucradas.

## Proyectos

### 1. **ORM - Metaprogramación**
Este proyecto consiste en la implementación de un **ORM** *(Object-Relational Mapper)* tipo **Active Record** utilizando conceptos de metaprogramación. El ORM permite mapear objetos del dominio a una base de datos, pudiendo definir a los atributos de una clase si pueden ser persistidos o no y añadiendo a la clase los metodos necesarios para poder persistir como un ORM Active Record.

#### Funcionalidades principales:
- **Mapeo Automático**: Generación de consultas SQL a partir de objetos.
- **Soporte para Relaciones**: Implementación de relaciones entre entidades (uno a uno, uno a muchos, muchos a muchos).
- **Validaciones Automáticas**: Validación de los datos antes de realizar operaciones sobre la base de datos.
- **Metaprogramación**: Uso de introspección para obtener metadatos de clases y generar automáticamente las consultas.

#### Tecnologías principales:
- **Lenguaje**: Ruby
- **Paradigma**: Metaprogramación
- **Pruebas**: RSpec

### 2. **Parsers - Objeto/Funcional**
Este proyecto se enfoca en la implementación de un sistema de *Parser Combinators* utilizando un enfoque híbrido entre la programación orientada a objetos y la funcional. Los *Parser Combinators* permiten combinar parsers simples para crear parsers más complejos y potentes, capaces de interpretar distintos lenguajes o expresiones. Este trabajo práctico se enfoca en construir parsers reutilizables y modulares, aplicando los principios de inmutabilidad, orden superior y uso del sistema de tipos.

#### Funcionalidades principales:
- **Parsers Básicos**: Implementación de parsers para caracteres, letras, números, y cadenas.
- **Combinators**: Implementación de combinadores como `OR`, `Concat`, `Rightmost` y `Leftmost` para construir parsers más complejos.
- **Parsers Avanzados**: Parsers para lenguajes específicos (como notas musicales o expresiones matemáticas).
- **Manejo de Errores**: Gestión de errores y resultados de parseo exitoso o fallido.

#### Tecnologías principales:
- **Lenguaje**: Scala
- **Paradigma**: Programación híbrida (Objeto-Funcional)
- **Pruebas**: ScalaTest

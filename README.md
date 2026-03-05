Preparcial – Internacionalización (I18N) con Next.js

Este proyecto corresponde al preparcial de la materia de desarrollo web, cuyo objetivo es implementar internacionalización (I18N) en una aplicación desarrollada con Next.js (App Router).

La aplicación soporta múltiples idiomas mediante rutas dinámicas, diccionarios JSON y detección de idioma.

Tecnologías utilizadas

Next.js 16

React

TypeScript

Node.js

App Router

Funcionalidades implementadas
1. Rutas dinámicas por idioma

La aplicación utiliza rutas dinámicas para manejar el idioma:

/es
/en
/es/profile
/en/profile

Cada ruta carga el contenido en el idioma correspondiente.

2. Diccionarios de traducción

Las traducciones se gestionan mediante archivos JSON ubicados en:

i18n/dictionaries

Ejemplo:

es.json

{
  "home": {
    "title": "Bienvenido"
  }
}

en.json

{
  "home": {
    "title": "Welcome"
  }
}

Esto permite separar completamente el contenido del código.

3. Carga dinámica de traducciones

Las traducciones se cargan mediante un helper:

i18n/get-dictionary.ts

Esto permite que los Server Components obtengan el diccionario correspondiente según el idioma.

4. Middleware de redirección

Se implementa un middleware que redirige automáticamente al idioma por defecto si la URL no lo especifica.

Ejemplo:

localhost:3000  →  /es
5. Cambio de idioma

La aplicación incluye un selector de idioma que permite cambiar entre:

Español
Inglés

El cambio actualiza la ruta y el contenido dinámicamente.

Estructura del proyecto
app
 ├─ [lang]
 │   ├─ layout.tsx
 │   ├─ page.tsx
 │   └─ profile
 │       └─ page.tsx
 │
components
 └─ LangSwitcher.tsx

i18n
 ├─ config.ts
 ├─ get-dictionary.ts
 └─ dictionaries
     ├─ es.json
     └─ en.json

middleware.ts
Ejecución del proyecto

Instalar dependencias:

npm install

Ejecutar en modo desarrollo:

npm run dev

Abrir en el navegador:

http://localhost:3000
Release del proyecto

Este repositorio incluye el release solicitado:

Parcial v0.0
Autor

Proyecto desarrollado por:

Jose Salgado

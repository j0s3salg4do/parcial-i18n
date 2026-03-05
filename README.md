
# Parcial – Desarrollo Web

Aplicación desarrollada con **Next.js (App Router)** que implementa **internacionalización (I18N)** mediante rutas dinámicas, diccionarios JSON y detección de idioma.

---

## Tecnologías

- Next.js  
- React  
- TypeScript  
- Node.js  

---

## Funcionalidades

- Rutas dinámicas por idioma

```
/es
/en
/es/profile
/en/profile
```

- Traducciones mediante **diccionarios JSON**

- Carga dinámica de traducciones en **Server Components**

- Redirección automática al idioma por defecto

- Selector de idioma (Español / Inglés)

---

## Estructura del proyecto

```
app/
 └─ [lang]/
     ├─ layout.tsx
     ├─ page.tsx
     └─ profile/
         └─ page.tsx

components/
 └─ LangSwitcher.tsx

i18n/
 ├─ config.ts
 ├─ get-dictionary.ts
 └─ dictionaries/
     ├─ es.json
     └─ en.json

middleware.ts
```

---

## Ejecutar el proyecto

Instalar dependencias:

```
npm install
```

Ejecutar en modo desarrollo:

```
npm run dev
```

Abrir en el navegador:

```
http://localhost:3000
```

---

## Release

El repositorio incluye el release solicitado:

```
Parcial v0.0
```

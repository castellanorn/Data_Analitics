## 📘 **Una mirada a las Ofertas de Data Analyst en Barcelona (Web Scraping + NLP)**  
  
### 📌 Descripción del Proyecto  
Este proyecto desarrolla un pipeline completo para analizar la demanda laboral en el sector de datos a partir de ofertas reales  
obtenidas mediante Web Scraping en tres portales: LinkedIn, Indeed y Adzuna.  
  
El flujo completo incluye:  
Automatización del scraping con Selenium  
Manejo de autenticación mediante cookies  
Adaptación a cambios dinámicos del HTML de los portales  
Limpieza y estructuración de datos  
Extracción de skills y requisitos mediante NLP  
Análisis comparativo entre portales  
Visualizaciones profesionales para identificar tendencias del mercado laboral  
  
El objetivo final es comprender qué skills, requisitos y familias profesionales son más demandadas para Data Analyst en Barcelona.  
Sin embargo el diseño de pipeline permite solicitar otros perfiles de empleo y otras ubicaciones.  
Es importante resaltar que estos datos son una mirada puntual de datos correspondientes a una semana en Febrero del 2026.
  
### 🏗️ Arquitectura del Proyecto   
📂 Codigo_proyecto/  
├──  Extraccion de Datos/  
│        ├──  WS_Indeed.ipynb  
│        ├──  WS_Linkedin.ipynb  
│        ├──  API_Adzuna.ipynb  
│        └──  Reconstruccion_Adzuna.ipynb  
├──  Preprocesamiento de Datos/  
│        ├──  Preparacion_datos.ipynb  
│        └──  Depuracion_datos.ipynb    
├──  Procesamiento de Datos/  
│        ├──  NLP_extraccion_skills.ipynb  
│        └──  NLP_extraccion_requisitos.ipynb  
├──  Estructuracion_skills_requisitos.ipynb   
└──  Visualizacion.ipynb  
  
📂 Datos_proyecto/   
├── df_Indeed.csv    
├── df_Linkedin.csv  
├── df_Adzuna.csv  
└── df_Adzuna_descripcion_editada.csv   
  
  
### 🕸️ 1. Web Scraping  
El scraping se implementó con Selenium, adaptado a las particularidades de cada portal.  
  
✔ LinkedIn  
Autenticación mediante cookies persistentes  
Adaptación al nuevo sistema de carga progresiva  
Extracción de jobcards con selectores robustos  
Manejo de pop-ups y redirecciones  
  
✔ Indeed  
Navegación paginada (start=0,10,20…)  
Manejo de banners de cookies  
Extracción de título, empresa, ubicación, resumen y enlace  
Eliminación de duplicados  
  
✔ Adzuna  
Scraping directo sin autenticación  
Extracción de descriciones.  
  
  
### 🧠 2. Procesamiento NLP  
El pipeline NLP transforma texto desestructurado en información analítica.   
  
Incluye:  
Limpieza y normalización del texto  
Extracción de skills mediante diccionarios ampliados  
Detección de skills emergentes con embeddings MiniLM  
Clasificación de familias profesionales  
Estandarización de requisitos:  
modalidad  
contrato  
jornada  
educación  
experiencia  
  
  
### 📊 3. Análisis y Visualizaciones  
Se generaron visualizaciones para identificar patrones:  
  
Barras apiladas por portal  
Heatmaps de requisitos y skills  
Treemaps por familia  
Radar charts comparativos  
Boxplots de complejidad de roles  
Wordclouds ponderadas por frecuencia  
  
  
### ⭐ 4. Principales Resultados  
  
Python, SQL comunicación e Inglés son los skills más demandados.  
Las soft skills resaltan a la par de las skills técnicas propias del perfil, y destacan especialmente en Indeed.  
La modalidad presencial se identifica en muy pocas ofertas, se desconoce si la no mención de modalidad debe inferirse como presencial.
LinkedIn es el portal más completo; Adzuna el más variable.  
  
  
### ⚙️ 5. Requisitos Técnicos  
  
Python 3.10+  
Selenium  
WebDriver Manager  
BeautifulSoap  
Pandas  
NumPy  
Scikit-learn  
Spacy  
SentenceTransformers  
Matplotlib / Seaborn  
  
  
### 📦 6. Estado del Proyecto  
  
✔ Web Scraping completado  
✔ Pipeline NLP implementado  
✔ Visualizaciones generadas  
✔ Resultados analizados  
✔ Presentación final realizada  
  
  
### 👩‍💻 7. Autora  
  
Rossemary Castellanos  
Especialización en Análisis de Datos  
Barcelona, España  

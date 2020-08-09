# Entornos Locales - Aper


## Instala Docker

### Instalar docker *https://get.docker.com/*

### Instalar docker-compose *https://www.digitalocean.com/community/tutorials/how-to-install-docker-compose-on-ubuntu-18-04*

#### Genérico *https://docs.docker.com/compose/install/*  

#### **Dentro del directorio donde hayas clonado el docker**

#### Tener Mysql clonado para el enlace con la BD. ` git@github.com:sanchezgregory/mysqldocker.git `
#### 1. **git clone** *https://gitlab.com/apernet/presta-nginx.git carpta_destino*

#### 2. ` cp .env.example .env `

 3.- Seguir las instrucciones del .env

 3.- a. docker-compose up --build  (levanta el docker y lo construye)  -> se ven los logs siempre
     b. docker-compose up -d build (levanta el docker lo construye y lo deja en segundo plano) -> no se ven los logs
 
  4.- Hasta aqui deberá comprobar que todo esté funcionando desde el explorador:
 	
 	https://localhost:"PORT_HTTPS"  ==> Mostrará error 400 Bad Request (obvio porque aun no tenemos el proyecto en la carpeta www)
 	Si no utilizó el parametro -d podrá ver los logs de acceso al docker mostrando algo como:

 	[ 172.18.0.1 - - [23/Nov/2018:18:11:06 +0000] "GET / HTTP/1.1" 400 673 "-" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.110 Safari/537.36" ]

  5.- Ahora deberá comprobar que tiene acceso a la BD. Desde mysql-workbench (o cualquiera de su preferencia)

  	Siguiendo los pasos para el docker-compose de Mysql

  6.- Clone el proyecto completo ya sea individualmente core, overrides, theme, modules, etc  o  simplemente ejecute el rsync.sh (elija la opcion 6.1 o 6.2) 

	6.1 (usando rsync.sh  "proyecto completo con imagenes")

		Editar el rsync.sh  y agregar la ubicacion del proyecto, este traerá todo el proyecto hacia la carpeta www. Por ejemplo
   			/home/$USER/prestaNginx/    "dentro de la carpeta donde se clonó el docker -> prestaNginx  se creará la carpeta www"

		- Imprescindible tener el .pem de icbcclub-dev
		- sudo chmod +x rsync.sh
		- sudo chmod 777 www/
		- ./rsync.sh
		
		Después de 5, 6 u 8 horas.... cuando termine el rsync

		cd www/  ----> core
			git status
			git reset --hard
			git flow init (enter a todo)
			git checkout develop
			git pull origin develop
		cd overrides/
			git status
			git reset --hard
			git flow init (enter a todo)
			git checkout develop
			git pull origin develop
		cd ..
		cd themes/icbcstore/
			git status
			git reset --hard
			git flow init (enter a todo)
			git checkout develop
			git pull origin develop
		cd modules/ (todos los modulos editables)
			git status
			git reset --hard
			git flow init (enter a todo)
			git checkout develop
			git pull origin develop

		git branch
		Si se observan branch diferentes a: "Master", "Develop" borrarlos con:
			git branch -D "NombreBranch"
			

	6.2 (Solo si no se usa el paso 6.1) baja modulo a modulo
		
		dentro de la carpeta del proyecto ("www/")
		1. git clone git@gitlab.com:apernet/icbcstore-core.git .
		2. git flow init  --> verificar que ya se encuentre en la rama develop
		3. git clone git@gitlab.com:apernet/icbcstore-override.git override
		4. git clone git@gitlab.com:apernet/icbcstore-theme.git themes/icbcstore
		5. git clone git@gitlab.com:apernet/presta-decidir2.0.git modules/decidir
		6. git clone git@gitlab.com:apernet/presta-vtex16.git modules/vtexmodule
		7. git clone git@gitlab.com:apernet/presta-productsmarks.git modules/productsmarks
		8. git clone git@gitlab.com:apernet/presta-productshippingcostcalculator.git modules/productshippingcostcalculator
		9. git clone git@gitlab.com:apernet/icbcstore-blocktopmenu.git modules/blocktopmenu
		10. git clone git@gitlab.com:apernet/presta-pointspayment.git modules/pointspayment

*nota: hacer los pasos siguientes desde /www
   7.- Eliminar el directorio cache/ (rm -rf cache) y crearlo (mkdir cache);  con todos (sin -r) los permisos (chmod 777 cache)
   8.- Eliminar el directorio themes/icbcstore/cache/ (rm -rf themes/icbcstore/cache/) y crearlo (mkdir themes/icbcstore/cache);  con todos (sin -r) los permisos (chmod 777 themes/icbcstore/cache)
   9.- Eliminar el directorio log/ y crearlo (mkdir log);  con todos (sin -r) los permisos (chmod 777 log)
   9.- Crear el archivo settings.inc.php en base al template (cp config/settings_template.inc.php config/settings.inc.php)
     9.1 - define('_DB_SERVER_', 'mysqldb');
           define('_DB_NAME_', '<db_name>');
           define('_DB_USER_', 'root');
           define('_DB_PASSWD_', 'root');
   10.- Crear el .htaccess  (touch .htaccess,  chmod 777 .htaccess)

   11.- Importar la base de datos
	
	Una vez importada la BD se deben editar:

		11.1 Para empezar con prestashop:  http (sin ssl) = "No activado"
		
		Tabla = PS_CONFIGURATION 
			Campo= [ PS_SHOP_DOMAIN] = "localhost:9000" 
			Campo= [ PS_SHOP_DOMAIN_SSL] = "localhost:9000"
			Campo= [ PS_SSL_ENABLED] = 0 
	
		Tabla = PS_SHOP_URL 
			Campo = [PS_SHOP_DOMAIN] = "localhost:9000"


		11.2 Para empezar con prestashop:  https (ssl)
		
		Tabla = PS_CONFIGURATION 
			Campo= [ PS_SHOP_DOMAIN] = "localhost:3000" 
			Campo= [ PS_SHOP_DOMAIN_SSL] = "localhost:3000"
			Campo= [ PS_SSL_ENABLED] = 1 
	
		Tabla = PS_SHOP_URL 
			Campo = [PS_SHOP_DOMAIN] = "localhost:3000"


		En la tabla ps_configuration el valor RECAPTCHA_API_KEY - Si existe hace la validacion. Para deshabilitar la funcion de 
		recaptcha, se cambia su nombre ej: RECAPTCHA_API_KEY_old

========================================================================
QUITAR CDN DE IMAGENES,  en backoffice.

Parametros Avanzados > Rendimiento > Servidor multimedia nº 1 > vacío
=======================================================================

   PARA USAR PUNTOS

	Dependiendo del dump de la base de datos.
        ALTER TABLE ps_pointspayment_detail_transactions add COLUMN  updated_redeem varchar(1) default 0 after reference;

	Configurar el modulo para ser usado en QA
	
	Modulos y servicios > Pointspayment > Auth/PO > OAUTH DOMAIN Prod: vacio / Test: https://oauth-club.aper.net
					    	      > PARTNER DOMAIN: Prod: vacio / Test: https://partner-club.aper.net
						      > Ambiente actual: Test (ambos selects)

=====================================================================

  PARA USAR DECIDIR
	
	Configurar a los proveedores con las siguientes credenciales:

	Modulos y servicios > Decidir 2.0 > PROVEEDORES
		
		ID_Site: 	9999991
		Private Key: 	1b19bb47507c4a259ca22c12f78e881f
		Public Key:	96e7f0d36a0648fb9a8dcb50ac06d260
		Descripcion:    Nombre del proveedor
		Nro Est. Visa:	depende del proveedor. Ejm (Datasoft: 15284011, Samsung: 15284011)


-




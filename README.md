## Entornos Locales - Aper

#### 1. **git clone** *https://github.com/sanchezgregory/nginx-proxy-multiple-website.git carpta_destino*

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

## Instala Docker

### Instalar docker *https://get.docker.com/*

### Instalar docker-compose *https://www.digitalocean.com/community/tutorials/how-to-install-docker-compose-on-ubuntu-18-04*

#### Genérico *https://docs.docker.com/compose/install/*  

#### **Dentro del directorio donde hayas clonado el docker**

#### **IMPORTANTE** 

##### Debe estar en carpetas separadas, tanto el docker mysqldb como cada uno de los dockers dockerphpnginx, pueden estar en el mismo nivel o en otras subcarpetas.

##### Tener Mysql clonado para el enlace con la BD. `git clone https://github.com/sanchezgregory/mysqldocker.git mysqlDb`

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

## Nivel automático.

### 1. Ubicarse dentro del directorio del docker

### 2. ejecutar `chmod +x build_docker.sh`

### 3. ejecutar `bash build_docker.sh`

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

## NIVEL MANUAL

#### 2. ` cp .env.example .env `
##### 2.1 Seguir los pasos de configuración en .env

#### 3. Debes elegir con cual versión de PHP vas a usar (Descomente la primera linea que desea utilizar en etc/php/Dockerfile)
#### 3.1  *para prestashop 1.6 utilizar FROM php:7.1.14-fpm*
#### 3.2  *para prestashop 1.7 utilizar FROM php:7.3.6-fpm*

#### 4.1  `docker-compose up --build`  levanta el docker y lo construye se ven los logs siempre
#### 4.2  `docker-compose up --build -d`  levanta el docker lo construye lo deja en segundo plano

#### La construcción del docker, lanza muchos warnings, esto es totalmente normal, y el proceso tarda aproximadamente 8 min.
 
#### 5. Copie el archivo index.php ubicado en etc/php/index.php a la carpeta www creada por el docker, para comprobar que la conexión entre el servicio WEB y el MysqlDB
#### 5.1. `sudo chown -R $USER. www/` 
#### 5.2. `cp etc/php/index.php www/`

#### 6. https://localhost:"PORT_HTTPS"

#### 6.1 Si observa el mensaje: *Access denied for user 'root'@'172.22.0.3' (using password: YES)*
##### 6.1.a Falta ejecutar el comando `docker exec -it mysqldb bash  /etc/user.sh`
##### 6.1.b Asegurese de ver el mensaje: *Connected successfully - OK*
#### 6.2 Para finalizar ejecute: `rm www/index.php`

### Desde ahora ya puede migrar su proyecto a la carpeta www/

##### 7. Ahora deberá comprobar que tiene acceso a la BD. Desde mysql-workbench (o cualquiera de su preferencia, siguiendo los pasos del readme.md del docker mysql)

##### 7.1 si ya se tiene el proyecto en alguna otra ubicación (verifique que los archivos ocultos se hayan copiado ), ejecutar `sudo rsync -rtv source_folder/ destination_folder/` ejemplo: `sudo rsync -rtv /home/user/entornos/stores/files/ /home/user/entornos/store_name/www/`

##### 8. Clone el proyecto completo ya sea individualmente core, overrides, theme, modules, etc  o  simplemente ejecute el rsync.sh (elija la opcion 6.1 o 6.2) 

##### 8.1 usando rsync.sh  "proyecto completo con imagenes"

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
			

##### 8.2 Solo si no se usa el paso 8.1 baja modulo a modulo
		
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

#### 9. **nota: hacer los pasos siguientes desde /www**

##### 10. Eliminar el directorio cache/ (rm -rf cache) y crearlo (mkdir cache);  con todos (sin -r) los permisos (chmod 777 cache)

##### 11. Eliminar el directorio themes/icbcstore/cache/ (rm -rf themes/icbcstore/cache/) y crearlo (mkdir themes/icbcstore/cache);  con todos (sin -r) los permisos (chmod 777 themes/icbcstore/cache)

##### 12. Eliminar el directorio log/ y crearlo (mkdir log);  con todos (sin -r) los permisos (chmod 777 log)

##### 13. Crear el archivo settings.inc.php en base al template (cp config/settings_template.inc.php config/settings.inc.php)

##### 13.1 `define('_DB_SERVER_', 'mysqldb');
           define('_DB_NAME_', '<db_name>');
           define('_DB_USER_', 'root');
           define('_DB_PASSWD_', 'root');`

##### 14. Crear el .htaccess  (touch .htaccess,  chmod 777 .htaccess)

##### 15. Importar la base de datos
	
##### 16. Una vez importada la BD se deben editar:

===========================================================================
##### 16.1 Para empezar con prestashop:  http (sin ssl) = "No activado"
###### Tabla = PS_CONFIGURATION 
			Campo= [ PS_SHOP_DOMAIN] = localhost:"PORT_HTTP"
			Campo= [ PS_SHOP_DOMAIN_SSL] = localhost:"PORT_HTTP"
			Campo= [ PS_SSL_ENABLED] = 0
	
###### Tabla = PS_SHOP_URL 
			Campo = [PS_SHOP_DOMAIN] = localhost:"PORT_HTTP"
============================================================================
##### 16.2 Para empezar con prestashop:  https (con ssl) = "Activado"
		
###### Tabla = PS_CONFIGURATION 
			Campo= [ PS_SHOP_DOMAIN] = localhost:"PORT_HTTPS"
			Campo= [ PS_SHOP_DOMAIN_SSL] = localhost:"PORT_HTTPS"
			Campo= [ PS_SSL_ENABLED] = 1 
	
###### Tabla = PS_SHOP_URL 
			Campo = [PS_SHOP_DOMAIN] = localhost:"PORT_HTTPS"
============================================================================

###### En la tabla ps_configuration el valor RECAPTCHA_API_KEY - Si existe hace la validacion. Para deshabilitar la funcion de recaptcha, se cambia su nombre ej: RECAPTCHA_API_KEY_old

###### QUITAR CDN DE IMAGENES,  en backoffice.

###### **Parametros Avanzados > Rendimiento > Servidor multimedia nº 1 > vacío**
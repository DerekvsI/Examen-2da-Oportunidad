% Permite agregar síntomas dinámicamente según lo que el usuario observe.
:- dynamic(sintoma/1).
:- dynamic(no_sintoma/1). % Para registrar que un síntoma no está presente.

% --- BASE DE CONOCIMIENTO: REGLAS DE DIAGNÓSTICO ---

% --- Problemas de REDES ---
diagnostico(problema_de_conexion_fisica) :-
    pregunta(no_hay_internet),
    pregunta(luces_router_apagadas).

diagnostico(fallo_en_router_o_modem) :-
    pregunta(no_hay_internet),
    pregunta(luces_router_encendidas_sin_senal),
    pregunta(dispositivos_no_obtienen_ip).

diagnostico(problema_con_proveedor_de_internet) :-
    pregunta(no_hay_internet),
    pregunta(router_funciona_correctamente_localmente),
    pregunta(varios_dispositivos_sin_internet).

diagnostico(problema_de_configuracion_red_local) :-
    pregunta(conexion_limitada_o_nula),
    pregunta(no_detecta_red_wifi).

diagnostico(problema_de_adaptador_red_dispositivo) :-
    pregunta(no_detecta_red_wifi),
    pregunta(otros_dispositivos_si_detectan_wifi).

% --- Problemas de HARDWARE ---
diagnostico(fuente_poder_defectuosa) :-
    pregunta(computadora_no_enciende),
    pregunta(no_hay_luces_en_placa_madre).

diagnostico(problema_memoria_ram) :-
    pregunta(computadora_no_enciende),
    pregunta(sonido_bips_arranque).

diagnostico(tarjeta_video_defectuosa) :-
    pregunta(computadora_enciende_pero_pantalla_negra),
    pregunta(no_se_muestra_nada_en_monitor_externo).

diagnostico(disco_duro_fallando) :-
    pregunta(rendimiento_lento_general),
    pregunta(ruidos_extranios_disco_duro),
    pregunta(archivos_desaparecen_o_corruptos).

diagnostico(sobrecalentamiento_hardware) :-
    pregunta(computadora_se_apaga_repentinamente),
    pregunta(temperatura_alta_cpu_o_gpu).

% --- Problemas de SOFTWARE ---
diagnostico(software_corrupto_o_incompatible) :-
    pregunta(programa_se_cierra_inesperadamente),
    pregunta(mensajes_de_error_aplicacion_especifica),
    pregunta(ocurre_despues_de_actualizacion).

diagnostico(infeccion_malware) :-
    pregunta(rendimiento_lento_general),
    pregunta(publicidad_emergente_no_deseada),
    pregunta(comportamiento_anormal_sistema_o_archivos).

diagnostico(drivers_incorrectos_u_obsoletos) :-
    pregunta(hardware_no_reconocido_o_funciona_mal),
    pregunta(exclamacion_en_administrador_dispositivos).

diagnostico(conflicto_software) :-
    pregunta(programa_se_cierra_inesperadamente),
    pregunta(ocurre_despues_de_instalar_nuevo_software).

diagnostico(sistema_operativo_danado) :-
    pregunta(pantalla_azul_de_la_muerte),
    pregunta(imposible_iniciar_sesion),
    pregunta(errores_arranque_sistema).

% --- REGLAS DE SOLUCIÓN SUGERIDAS ---
solucion(problema_de_conexion_fisica, 'Verifique que el cable de red esté conectado firmemente al router y a su dispositivo. Reinicie el router.').
solucion(fallo_en_router_o_modem, 'Intente reiniciar el router y el módem. Si el problema persiste, contacte a su proveedor de internet.').
solucion(problema_con_proveedor_de_internet, 'Contacte a su proveedor de servicios de internet para verificar si hay una interrupción del servicio en su área.').
solucion(problema_de_configuracion_red_local, 'Verifique la configuración de red en su dispositivo (IP, DNS). Intente restablecer el adaptador de red.').
solucion(problema_de_adaptador_red_dispositivo, 'Revise el estado del adaptador de red en el Administrador de Dispositivos. Podría necesitar actualizar o reinstalar los drivers.').
solucion(fuente_poder_defectuosa, 'Verifique las conexiones de la fuente de poder. Si es posible, pruebe con otra fuente de poder. Podría necesitar un técnico.').
solucion(problema_memoria_ram, 'Apague la computadora, retire los módulos de RAM, limpie los contactos y vuelva a insertarlos firmemente. Si tiene varios, pruebe con uno a la vez.').
solucion(tarjeta_video_defectuosa, 'Asegúrese de que el monitor esté conectado a la tarjeta de video correcta. Si tiene una tarjeta de video dedicada, pruebe con la gráfica integrada de la placa base (si aplica). Podría ser necesario reemplazarla.').
solucion(disco_duro_fallando, 'Realice una copia de seguridad de sus datos importantes inmediatamente. Ejecute una herramienta de diagnóstico de disco (como CHKDSK en Windows). Podría necesitar reemplazar el disco.').
solucion(sobrecalentamiento_hardware, 'Limpie el polvo de los ventiladores y disipadores de calor. Asegúrese de que el flujo de aire sea adecuado en el gabinete. Verifique la pasta térmica del CPU.').
solucion(software_corrupto_o_incompatible, 'Intente desinstalar y reinstalar el programa. Si el problema persiste, busque una versión más reciente o alternativa compatible.').
solucion(infeccion_malware, 'Ejecute un escaneo completo con un antivirus actualizado. Considere utilizar herramientas antimalware adicionales. Evite sitios web sospechosos.').
solucion(drivers_incorrectos_u_obsoletos, 'Actualice los drivers desde el sitio web oficial del fabricante del hardware. Si el problema comenzó después de una actualización, intente revertir el driver.').
solucion(conflicto_software, 'Desinstale el software que instaló recientemente y que coincide con el inicio del problema.').
solucion(sistema_operativo_danado, 'Intente utilizar las opciones de recuperación del sistema operativo (restaurar sistema, reparar inicio). Si el problema persiste, podría ser necesaria una reinstalación del SO (respalde sus datos antes).').


% --- PREDICADOS DE CONTROL Y CONSULTA ---

% Pregunta al usuario sobre un síntoma y lo almacena.
pregunta(Sintoma) :-
    sintoma(Sintoma), !. % Si el síntoma ya fue afirmado, no preguntar de nuevo.
pregunta(Sintoma) :-
    no_sintoma(Sintoma), !, fail. % Si el síntoma ya fue negado, fallar inmediatamente.
pregunta(Sintoma) :-
    format('¿Se presenta el síntoma "~w"? (s/n)~n', [Sintoma]),
    read(Respuesta),
    ( (Respuesta == s ; Respuesta == si) ->
        asserta(sintoma(Sintoma))
    ;
        asserta(no_sintoma(Sintoma)),
        fail % Si la respuesta es 'n' o 'no', se asume que no se presenta y se fuerza el backtracking.
    ).

% Predicado para iniciar el diagnóstico.
iniciar_diagnostico :-
    retractall(sintoma(_)), % Limpia los síntomas de ejecuciones anteriores
    retractall(no_sintoma(_)), % Limpia las negaciones de síntomas anteriores
    write('--- INICIANDO DIAGNÓSTICO DE FALLAS TECNOLÓGICAS ---'), nl,
    write('Por favor, responda con "s" (sí) o "n" (no) a las siguientes preguntas.'), nl,
    find_diagnostics.

% Encuentra todos los diagnósticos posibles y sus soluciones.
find_diagnostics :-
    ( diagnostico(Falla) ->
        write('--- DIAGNÓSTICO ENCONTRADO ---'), nl,
        format('Posible problema: ~w~n', [Falla]),
        ( solucion(Falla, Solucion) ->
            format('Sugerencia de solución: ~w~n', [Solucion])
        ;
            write('No hay una solución específica sugerida para este diagnóstico.'), nl
        ),
        nl,
        fail % Fuerza el backtracking para encontrar otros diagnósticos
    ;
        write('--- DIAGNÓSTICO COMPLETADO ---'), nl,
        write('No se encontraron más diagnósticos basados en los síntomas proporcionados.'), nl
    ).

find_diagnostics. % Este último predicado es para asegurar que find_diagnostics siempre termine.

# RCRA

Para poder ver las soluciones por pantalla de los puzzle usar estos comando (Yo no tengo python3 asi que lo hice con python):

python decode.py masyuKB.lp masyu01.lp
python decode.py masyuKB.lp masyu02.lp
python decode.py masyuKB.lp masyu03.lp
python decode.py masyuKB.lp masyu04.lp
python decode.py masyuKB.lp masyu05.lp
python decode.py masyuKB.lp masyu06.lp

Para escribir en un archivo .txt las soluciones se usaron los comandos:
python decode.py masyuKB.lp masyu01.lp >solution01.txt
python decode.py masyuKB.lp masyu02.lp >solution02.txt
python decode.py masyuKB.lp masyu03.lp >solution03.txt
python decode.py masyuKB.lp masyu04.lp >solution04.txt
python decode.py masyuKB.lp masyu05.lp >solution05.txt
python decode.py masyuKB.lp masyu06.lp >solution06.txt

Si se quiere comprobar que den una sola solución se debe ir al código de masyuKB.lp y arriba del todo se tiene que poner como comentario la linea size(n) y luego descomentar una de las linea de abajo, las cuales tienen los datos de cada puzzle. Estas linea están en orden, es decir la primera linea corresponde a masyu01.lp, la segunda a masyu02.lp y de ahi hasta el último puzzle. Una vez realizado este proceso se debe usar el comando:
clingo 0  masyuKB1.lp

NOTA: Esta por defecto activado el #show seg/2, el cual solo muestra los segmentos de la solución. 

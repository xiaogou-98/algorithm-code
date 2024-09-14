# import pandas as pd
import copy
from os import pardir
import random
import math

from clases.ClientData import ClientData
from clases.Individual import Individual

# IMPLEMENTAR CONTROL DE REPETIDOS, VER POR QUÉ LA DEGRADACIÓN DE NICHO AFECTA AL CROSSOVER CUANDO ES 1

# los tres primeros datos serán cargados al leer el archivo
CAPACITY = 0
N_CLIENTS = 0
NUMBER_OF_GENES: int = 0
DC_NUM = 0
PC_NUM = 0
NUMERO_DE_INDIVIDUOS = 80
MAX_GENERATION_NUMBER = 150
PROPORCION_ELITISTA = 0.15
PROPORCION_CROSSOVER = 0.80
PROPORCION_MUTACION = 0.02 # porcentaje de individuos de cada genración expuestos a la mutación
MUTATION_RATE= 0.000 # probabilidad de mutación
INCLUIR_TIEMPO_ESPERA = False # Cambiar este para controlar si incluir a la distancia total (en tiempo) el tiempo que cada vehículo espera al llegar temprano
dict_individual_number = {} # variable global diccionario para mapear individuos a sus indices


def read_file(file_location_path):
# función para leer el archivo y procesar para que pueda ser utilizado
    clients_data = []
    with open(file_location_path) as data:
        for i, line in enumerate(data):
            global CAPACITY
            global N_CLIENTS
            global NUMBER_OF_GENES
            global DC_NUM
            global PC_NUM
            if i == 1: 
                N_CLIENTS = int(line) - 1
                NUMBER_OF_GENES = int(line) - 1
            if i == 3: CAPACITY = int(line)
            if i == 5: DC_NUM = int(line)
            if i == 7: PC_NUM = int(line)
            if i > 8:
                cols = line.split()
                clients_data.append(ClientData(
                    client_number = int(cols[0]), 
                    x = int(cols[1]), 
                    y = int(cols[2]), 
                    demand = int(cols[3]),
                    ready_time = int(cols[4]),
                    due_date = int(cols[5]),
                    service_time = int(cols[6])
                ))
    return clients_data;

def inicializar_poblacion(depot_data, clients_data):
# función que instancia todos los individuos de la población
    poblacion = []
    for _ in range(NUMERO_DE_INDIVIDUOS):
        # generamos un individuo nuevo
        indiv = Individual(depot_data, clients_data, CAPACITY)
        # generamos su ruta de manera aleatoria, luego hacemos la reperación heurísitca a la ruta para que sea valida
        indiv.generate_random_individual()
        indiv.reparacion_heuristica_y_calculo_objetivos(INCLUIR_TIEMPO_ESPERA)
        # lo agregamos a la población
        poblacion.append(indiv)

    return poblacion

def ranking_de_frentes(poblacion):
# función que se encarga de clasificar a toda la población en frentes pareto y en base a eso asignarles un dummy fitness
    front = 0
    poblacion_actual = poblacion
    poblacion_en_frentes = []
    # mientras todos los individuos no pertenezcan a un frente
    while(poblacion_no_clasificada(poblacion, poblacion_en_frentes)):
        # se creará un nuevo frente pareto para clasificar individuos
        front+= 1
        # calculamos un nuevo frente
        nuevo_frente, poblacion_actual = calcular_frente(poblacion_actual, front)
        # print('frente {}'.format(front))
        # for ind in nuevo_frente:
        #     print(dict_individual_number[ind])
        poblacion_en_frentes += nuevo_frente
    
    
def poblacion_no_clasificada(poblacion, poblacion_en_frentes):
# mientras los individuos en un frente pareto sean < que la población total significa que no se han clasificado todos los individuos
    # print('termina? {}'.format(not(len(poblacion) > len(poblacion_en_frentes))))
    return len(poblacion) > len(poblacion_en_frentes)

def calcular_frente(poblacion_actual, front):
# función que calcula el frente pareto de la población actual
    nuevo_frente = []
    for individuo in poblacion_actual:
        es_dominado = False
        for individuo_comp in poblacion_actual:
            # si el individuo con el que estamos comparando domina a nuestro individuo entonces ponemos en true la bandera
            if verificar_si_domina(individuo_comp, individuo):
                es_dominado = True 
        # si el individuo es no dominado
        if es_dominado == False:
            # lo asignamos al frente pareto
            nuevo_frente.append(individuo)
    # luego calculamos el fitness de cada individuo en el frente calculado recientemente
    for indiv_en_frente in nuevo_frente:
        indiv_en_frente.calcular_fitness_final(front ,nuevo_frente) # también debemos hacer la degradación de nicho
    # quitamos los elementos de la poblacion actual que ya están en el frente
    poblacion_actual = [item for item in poblacion_actual if item not in nuevo_frente]

    return nuevo_frente, poblacion_actual

def verificar_si_domina(individuo_A, individuo_B):
# función para verificar si un individuo domina sobre otro
    domina = False
    indcv = individuo_A.cantidad_vehiculos    
    indtv = individuo_A.tiempo_total_vehiculos
    iccv = individuo_B.cantidad_vehiculos
    ictv = individuo_B.tiempo_total_vehiculos
    if (indcv <= iccv and indtv <= ictv ):
        if (indcv < iccv or indtv < ictv):
            domina = True;
        else:
            domina = False;
    return domina

def dibujar_frente_pareto(poblacion):
# función para graficar el frente pareto teniendo como eje x a F1(cant vehiculos) y como eje y a F2(tiempo total vehiculos)
# Para guardar el gráfico, llamar solo a esta función en main y ejecutamos el comando: python script.py > matriz.txt
    # inicializamos la matriz
    matriz = [[' ' for col in range(100)] for row in range(100)]
    # recorremos todos los individuos de la población
    for i in range(0,len(poblacion)):
        cant_vehiculos = poblacion[i].get_fitness_objetivos()[0]
        tiempo_total = poblacion[i].get_fitness_objetivos()[1]
        # convertimos el rango [21000,27000] a [0,100]
        tiempo_total = int (((tiempo_total - 20000)/(30000 -21000) ) * 100)
        # ahora cargamos en la matriz
        matriz[cant_vehiculos][tiempo_total] = i
        # guardamos en el diccionario para poder saber que individuo entró en cada frente
        dict_individual_number[poblacion[i]] = i
    # por último imprimimos el gráfico
    # aclaración: esta impresión hace que la Y sea la F1 y la X la F2
    for i in range(100):
        print(" {}".format(matriz[i]))
    print("\n")

def ordenar_poblacion_por_fitness(poblacion):
#ordenamos la población según el fitness final calculado
    poblacion.sort(key= lambda individual: individual.fitness, reverse= True)

def seleccion_elitista(poblacion):
# elegimos de manera elitista al 10% mejor de la población para que pase a la siguiente generación
    # cant is the amount of elements of the population to be select with elistism
    cant = int(NUMERO_DE_INDIVIDUOS*PROPORCION_ELITISTA)
    # we select the 'cant' amount of elements and append to the sucesors list
    siguiente_generacion = []
    # ordenamos la población en orden de su fitness
    ordenar_poblacion_por_fitness(poblacion)
    # luego copiamos la proporcion
    for ind in range(0,cant):
        siguiente_generacion.append(poblacion[ind])
    
    return siguiente_generacion

def mutacion(poblacion):
# función que agarra a la población de la nueva generación y tiene cierta probabilidad de mutar algunos de sus genes
    # first we calculate the amount of elements to be mutated
    cant = math.ceil(PROPORCION_MUTACION * len(poblacion))
    # print("cantidad de individuos a mutar: {}".format(cant))
    # then we choose those elements
    for i in range(0,cant):
        indiv = random.choice(poblacion)
        # for each element we mutate every gene with a probability of 0.04
        size = len(indiv.get_ruta())
        for g in range(size):
            if( random.random() <= MUTATION_RATE ):
                # comprobamos que el gen elegido no sea 0 y si es elegimos el gen anterior
                if indiv.get_ruta()[g] == 0:
                    g-=1
                # if there will be a mutation we choose another gen index and we swap both
                swap = random.randint(0,size-1)
                # volvemos a elegir otro gen al azar hasta que el gen swap sea diferente al gen g y el gen swap no sea 0
                while swap == g or indiv.get_ruta()[swap] == 0:
                    swap = random.randint(0,size-1)
                # print("mutación en individuo {}: {}={}>".format(indiv,indiv.get_ruta()[g],indiv.get_ruta()[swap]))
                indiv.get_ruta()[g],indiv.get_ruta()[swap] = indiv.get_ruta()[swap],indiv.get_ruta()[g]
        # luego de realizar la mutación debemos aplicar las correcciones heurísticas para validar las nuevas rutas del individuo
        indiv.reparacion_heuristica_y_calculo_objetivos(INCLUIR_TIEMPO_ESPERA)


def reproduccion_crossover_cxOrdered(poblacion):
# función que realiza la reproducción de individuos mediante crossover. Previamente elige cada par con la ruleta
    # en primer lugar leemos el archivo para poder pasar los parámetros necesarios a los nuevos individuos que se generen
    data = read_file("Instance.txt");
    clients_data = data[1:]
    depot_data = data[0]
    nueva_generacion = []
    # repetir mientras el tamaño de la nueva generación sea menor a la proporcion de sucesores que debe generar el crossover
    while(len(nueva_generacion) < ( NUMERO_DE_INDIVIDUOS * PROPORCION_CROSSOVER)):
        # elegimos un padre y una madre con la técnica de la ruleta
        padre = get_parent_usando_ruleta(poblacion)
        madre = get_parent_usando_ruleta(poblacion)
        # comprobamos que no sea el mismo individuo
        while padre == madre:
            madre = get_parent_usando_ruleta(poblacion)
        # padre = random.choice(poblacion)
        # madre = random.choice(poblacion)
        # cargamos las rutas sin los ceros
        ruta_padre_raw = []
        for gen in padre.get_ruta():
            if gen != 0:
                ruta_padre_raw.append(gen)
        ruta_madre_raw = []
        for gen in madre.get_ruta():
            if gen != 0:
                ruta_madre_raw.append(gen)
        # restamos un valor a todos para poder utilizarlos de indice. Si son 100 elementos que vaya de 0 a 99
        ruta_padre = [x-1 for x in ruta_padre_raw]
        ruta_madre = [x-1 for x in ruta_madre_raw]
        # elegimos dos puntos de corte al azar
        lon = min(len(ruta_madre),len(ruta_padre))
        p1, p2 = random.sample(range(lon), 2)
        # verificamos que p1 sea menor a p2 para poder realizar los cortes
        if p1 > p2:
            p1, p2 = p2, p1
        # ahora realizamos los cortes creando dos vectores hoyo con False donde corresponda a los hoyos
        hoyo1, hoyo2 = [True]*lon, [True]*lon
        for i in range(lon):
            if i < p1 or i > p2:
                # acá marcamos que valores van a venir del otro progenitor
                hoyo1[ruta_madre[i]] = False
                hoyo2[ruta_padre[i]] = False
        # guardamos los valores originales en variables temporales
        temp_padre, temp_madre = ruta_padre, ruta_madre
        # vamos moviendo a un lado las rutas
        k1, k2 = p2+1, p2+1
        for i in range(lon):
            if not hoyo1[temp_padre[(i+p2+1)%lon]]:
                ruta_padre[k1%lon] = temp_padre[(i+p2+1) % lon]
                k1 += 1
            if not hoyo2[temp_madre[(i+p2+1) % lon]]:
                ruta_madre[k2%lon] = temp_madre[(i+p2+1) % lon]
                k2 += 1
        # luego hacemos swap de los contenidos entre p1 y p2 (incluidos)
        for i in range(p1, p2+1):
            ruta_padre[i], ruta_madre[i] = ruta_madre[i], ruta_padre[i]
        # volvemos a sumar 1 a los valores que restamos 1
        ruta_padre = [x+1 for x in ruta_padre]
        ruta_madre = [x+1 for x in ruta_madre]
        # ahora que ya tenemos las dos nuevas rutas resultado de la reproducción procedemos a crear dos nuevos individuos
        # primer hijo
        hijo1 = Individual(depot_data,clients_data, CAPACITY)
        hijo1.genes = ruta_padre
        # realizamos las reparaciones heuristicas a al primera ruta
        hijo1.reparacion_heuristica_y_calculo_objetivos(INCLUIR_TIEMPO_ESPERA)
        # por último añadimos los dos hijos a la población de la nueva generación
        nueva_generacion.append(hijo1)
        # para el segundo hijo debemos primero tener en cuenta que no se esté poniendo individuos de más
        if ( (len(nueva_generacion)+PROPORCION_ELITISTA*NUMERO_DE_INDIVIDUOS) < NUMERO_DE_INDIVIDUOS):
            hijo2 = Individual(depot_data,clients_data, CAPACITY)
            hijo2.genes = ruta_madre
            # realizamos las reparaciones heuristicas a al segunda ruta
            hijo2.reparacion_heuristica_y_calculo_objetivos(INCLUIR_TIEMPO_ESPERA)
            # lo añadimos a la 2da generación
            nueva_generacion.append(hijo2)
        # luego hacemos 0 los fitness de los padres para que no vuelvan a cruzarce
        padre.fitness = 0
        madre.fitness = 0
    return nueva_generacion

def get_parent_usando_ruleta(poblacion):
# función para obtener un padre con la técnica de la ruleta para aplicar la reproducción
    # obtenemos la suma total de fitness de todos los individuos
    total_fitness = int(get_total_fitness(poblacion))
    # elegimos un punto random que será el individuo a elegir
    random_select_point = random.randint(1,total_fitness)
    sumatoria_actual = 0
    for i in range(NUMERO_DE_INDIVIDUOS):
        # vamos sumando los valores de fitness
        sumatoria_actual += poblacion[i].fitness
        #hasta llegar o superar al punto random elegido entonces retornamos el individuo que llegó a ese punto
        if sumatoria_actual >= random_select_point:
            return poblacion[i]

def get_total_fitness(poblacion):
# función que retorna la sumatoria de fitness de toda la población
    total_fitness = 0
    for individuo in poblacion:
        total_fitness += individuo.fitness
    return total_fitness

def get_avg_from_orgs(orgs):
    return get_total_fitness(orgs) / NUMERO_DE_INDIVIDUOS

def son_individuos_iguales(individuo1, individuo2):
# compara las rutas de dos individuos y retorna true si son iguales
    return individuo1.get_ruta() == individuo2.get_ruta()

def controlar_repetidos(poblacion):
# función que se encarga de eliminar un elemento si se encuentra repetido más de 2 veces en la población y agregar un random en su lugar
    cant_reps= [ 0 for x in range(100) ]
    tam_poblacion = len(poblacion)
    # los for van en reversa para poder ir dando valores de n-1 al último repetido hasta 0 al original 
    for i in range(tam_poblacion-1,-1,-1):
        for j in range(0, i, 1,):
            if son_individuos_iguales(poblacion[i], poblacion[j]):
                cant_reps[i] +=1
    
    # primeramente conseguimos los valores para crear individuos
    data = read_file("Instance.txt");
    clients_data = data[1:]
    depot_data = data[0]
    
    # ahora a todos los elementos repetidos serán reemplazados por individuos random
    for i in range(len(cant_reps)):
        # si es un repetido
        if cant_reps[i] > 0:
            # generamos un nuevo individuo random
            indiv = Individual(depot_data, clients_data, CAPACITY)
            indiv.generate_random_individual()
            indiv.reparacion_heuristica_y_calculo_objetivos(INCLUIR_TIEMPO_ESPERA)
            # insertamos el nuevo individuo random en su posición
            poblacion[i] = indiv
    # print(cant_reps)

def cantidad_repetidos(poblacion):
# función que cuenta la cantidad de repetidos
    cant_reps = 0
    tam_poblacion = len(poblacion)
    # los for van en reversa
    for i in range(tam_poblacion):
        for j in range(tam_poblacion):
            if i != j and son_individuos_iguales(poblacion[i], poblacion[j]):
                cant_reps +=1
    print(cant_reps)

def nsga(poblacion):
# función que realiza el ciclo o la generación de la población según el método MOEA NSGA
    generacion = 1
    # mientras no se cumpla la condición de parada. Cada ciclo del while es una generación
    while(not condicion_parada(generacion)):
        # realizamos el ranking de frentes para clasificar a la población y darles un fitness
        ranking_de_frentes(poblacion)
        # ordenamos a la población de acuerdo a su fitness
        ordenar_poblacion_por_fitness(poblacion)
        # Mostramos al mejor individuo de la generación actual
        print('generacion {}: Mejor individuo = Fitness: {}, cant vehiculos: {}, tiempo total: {}'.format(generacion,poblacion[0].fitness,poblacion[0].cantidad_vehiculos,poblacion[0].tiempo_total_vehiculos))
        # procedemos a la selección y reproducción:
        nueva_generacion = []
        # primero elegimos a los mejores de la generación actual y los hacemos pasar a la nueva generación
        nueva_generacion += seleccion_elitista(poblacion)
        # luego realizamos crossover para generar los individuos de la nueva generación
        nueva_generacion += reproduccion_crossover_cxOrdered(poblacion)
         # luego mutamos con cierta probabilidad un porcentaje de la nueva población
        mutacion(nueva_generacion)
        # APORTE PERSONAL: si encontramos en una misma población elementos repetidos, entonces los cambiamos por individuos random para favorecer la exploración
        controlar_repetidos(nueva_generacion)
        # luego incrementamos el número de generación
        generacion += 1
        # pasamos la nueva generación a la población actual (haciendo un deep copy)
        poblacion = nueva_generacion
    # al terminar el while debemos calcular el ranking de frentes de la última nueva generación y ordenar por fitness
    ranking_de_frentes(poblacion)
    ordenar_poblacion_por_fitness(poblacion)
    # finalmente mostramos al mejor individuo final
    print('generacion {} (FINAL): Mejor individuo = Fitness: {}, cant vehiculos: {}, tiempo total: {}'.format(generacion-1,poblacion[0].fitness,poblacion[0].cantidad_vehiculos,poblacion[0].tiempo_total_vehiculos))


def condicion_parada(generacion):
# función donde pondremos las condiciones para que el ciclo NSGA se detenga
    parada = False
    # primera condición: cantidad de iteraciones
    if (generacion > MAX_GENERATION_NUMBER):
        parada = True
    return parada


def main():
    data = read_file("Instance.txt");
    clients_data = data[1:]
    depot_data = data[0]
    poblacion = inicializar_poblacion(depot_data, clients_data)
    
    # dibujar_frente_pareto(poblacion)

    nsga(poblacion)

main()

### Inicializar
### Clasificar en frentes 
### Seleccion de sgte. poblacion
### Criterio de parada ( Nro. de generaciones - Que no cambien los frentes x n generaciones )
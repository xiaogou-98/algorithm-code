import copy
import random
import math

class Individual(object):

    def generate_random_individual(self):
        # función que genera individuos aleatorios
        clients_to_visit = copy.deepcopy(self.clients_data)
        path = []
        while clients_to_visit:
            # mientras hayan clientes en la lista a visitar, se elige un cliente random
            index = random.randint(0, len(clients_to_visit)-1)
            # if index == len(clients_to_visit): #Adding a truck!
            #     path.append(0)
            # else: #Adding valid values
            # y se guarda el cliente random en la lista path
            path.append( clients_to_visit[index].client_number )
            # luego se borra al cliente de la lista original
            del clients_to_visit[index]

        #guardamos path en el array genes, será un array de números que simbolizan el número del cliente.
        self.genes = path # Genes is an array with the client_number of the clients_data vector

    def heuristic_repair_and_objectives_with_tw(self):
    # este algoritmo realiza la reparación heurísitca y al mismo tiempo calcula el fitness con las variables globales:
    # self.cantidad_vehiculos y self.tiempo_total_vehiculos.
        # primeramente inicializamos de nuevo estas variables por si la función corra 2 veces
        self.cantidad_vehiculos = 1;
        self.tiempo_total_vehiculos = 0;
        
        new_genes_valid_capacity = []
        total_cargo = 0
        for client_number in self.genes:
            position = self.clients_data[ client_number - 1]
            total_cargo += position.demand # Load the cargo with the demand
            if total_cargo >= self.max_capacity: #If the cargo is greater than the max
                new_genes_valid_capacity.append(0) #Add new truck here
                self.cantidad_vehiculos+=1 # se añade un vehículo a la cantidad
                # si el otro camión se llenó entonces le ponemos a este la carga desde el punto
                # por eso se inicializa de nuevo total_cargo a ese valor
                total_cargo = position.demand # THe new truck will have a new capacity
        #     #If not, just continue the visit of the next client
            new_genes_valid_capacity.append(client_number)
        
        #With the logic above new_genes has valid travels for many trucks that doesnt violate the capacity restriction
        #Now we have to repair the time windows
        
        new_genes_valid_time = []
        time = 0
        position = self.depot_data
        for client_number in new_genes_valid_capacity:
            if client_number == 0:
                time = 0# Restart time because this is a new truck
                position = self.depot_data
            else:
                client_to_serve = self.clients_data[ client_number - 1 ]

                time +=  position.get_distance_to_client( client_to_serve )
                
                # Sumamos primero al tiempo total el tiempo en llegar del punto actual al destino
                self.tiempo_total_vehiculos += position.get_distance_to_client( client_to_serve ) 

                if client_to_serve.can_serve_in_timepoint(time):
                    position = client_to_serve
                    if client_to_serve.timepoint_is_before(time): # si llegamos antes, esperamos....
                        
                        # si debe esperar entonces se carga el tiempo de espera + el tiempo de servicio
                        self.tiempo_total_vehiculos += (client_to_serve.ready_time - time) + client_to_serve.service_time
                        
                        time = client_to_serve.ready_time + client_to_serve.service_time
                    else:
                        time += client_to_serve.service_time # if we arrive on time we just add the time
                        
                        # si no se debe esperar entonces se carga solamente el tiempo de servicio
                        self.tiempo_total_vehiculos += client_to_serve.service_time 

                # si no puede llegar o completar el servicio en la ventana de tiempo
                else:
                    new_genes_valid_time.append(0) # Add new truck
                    self.cantidad_vehiculos+=1 # se añade un vehículo a la cantidad
                    time = client_to_serve.ready_time + client_to_serve.service_time # Restart time because this is a new truck
                    position = client_to_serve
                    

                    # se suma la distancia del deposito al destino (por ser un nuevo vehículo) + tiempo de servicio
                    pos_depot = self.depot_data
                    self.tiempo_total_vehiculos += pos_depot.get_distance_to_client( client_to_serve ) + client_to_serve.service_time
                    # además también debemos sumar el tiempo que le tarda al vehículo viejo en volver al deposito
                    self.tiempo_total_vehiculos += position.get_distance_to_client( pos_depot )
                    # y restamos el tiempo del viejo al cliente ya que al final no fue
                    self.tiempo_total_vehiculos -= position.get_distance_to_client( client_to_serve )             
            new_genes_valid_time.append(client_number)
        
        self.genes = new_genes_valid_time

    def heuristic_repair(self):
        # este algoritmo realiza la reparación heurísitca:
        new_genes_valid_capacity = []
        total_cargo = 0
        for client_number in self.genes:
            position = self.clients_data[ client_number - 1]
            total_cargo += position.demand # Load the cargo with the demand
            if total_cargo >= self.max_capacity: #If the cargo is greater than the max
                new_genes_valid_capacity.append(0) #Add new truck here
                # si el otro camión se llenó entonces le ponemos a este la carga desde el punto
                # por eso se inicializa de nuevo total_cargo a ese valor
                total_cargo = position.demand # THe new truck will have a new capacity
            #If not, just continue the visit of the next client
            new_genes_valid_capacity.append(client_number)
        
        #With the logic above new_genes has valid travels for many trucks that doesnt violate the capacity restriction
        #Now we have to repair the time windows
        
        new_genes_valid_time = []
        time = 0
        position = self.depot_data
        for client_number in new_genes_valid_capacity:
            if client_number == 0:
                time = 0# Restart time because this is a new truck
                position = self.depot_data
            else:
                client_to_serve = self.clients_data[ client_number - 1 ]

                time +=  position.get_distance_to_client( client_to_serve )
                
                if client_to_serve.can_serve_in_timepoint(time):
                    position = client_to_serve
                    if client_to_serve.timepoint_is_before(time): # si llegamos antes, esperamos....
                        time = client_to_serve.ready_time + client_to_serve.service_time
                    else:
                        time += client_to_serve.service_time # if we arrive on time we just add the time

                # si no puede llegar o completar el servicio en la ventana de tiempo
                else:
                    new_genes_valid_time.append(0) # Add new truck
                    time = client_to_serve.ready_time + client_to_serve.service_time # Restart time because this is a new truck
                    position = client_to_serve               
            new_genes_valid_time.append(client_number)
             
        self.genes = new_genes_valid_time
        # llamamos a la función para calcular los valores de las funciones objetivo a optimizar
    
    def calcular_objetivos_a_optimizar(self):
        self.cantidad_vehiculos = 1
        self.tiempo_total_vehiculos = 0
        
        # ruta = [20, 21, 52, 49, 47, 0, 67, 65, 63, 62, 74, 72, 61, 64, 68, 66, 69, 0, 5, 3, 7, 8, 9, 6, 4, 1, 75, 0, 24, 25, 27, 28, 26, 23, 22, 2, 91, 0, 43, 42, 41, 40, 44, 45, 48, 50, 0, 10, 11, 100, 99, 89, 0, 29, 30, 36, 34, 0, 90, 87, 86, 88, 79, 80, 0, 46, 51, 0, 57, 55, 54, 53, 56, 58, 60, 59, 0, 13, 17, 18, 19, 15, 16, 14, 12, 0, 98, 96, 95, 94, 93, 97, 85, 0, 32, 33, 31, 35, 37, 38, 39, 0, 83, 82, 84, 77, 0, 81, 78, 76, 71, 70, 73] # self.get_ruta() 
        ruta = self.get_ruta() 
        origen = self.depot_data
        # empezamos a recorrer la ruta
        for i in range(len(ruta)):
            # si el destino es el deposito
            if ruta[i] == 0:
                destino = self.depot_data
                self.cantidad_vehiculos += 1
            else:   
                destino = self.clients_data[ruta[i]-1]
            # calculamos el costo total en base a las distancias
            self.tiempo_total_vehiculos += origen.get_distance_to_client(destino)
            # pasamos el destino para que sea el nuevo origen
            origen = destino
        # por último sumamos la última distancia que es del último cliente al deposito
        self.tiempo_total_vehiculos += origen.get_distance_to_client(self.depot_data)
        # return self.cantidad_vehiculos, self.tiempo_total_vehiculos

    def reparacion_heuristica_y_calculo_objetivos(self, incluir_tiempo_espera):
        self.quitar_ceros()
        if incluir_tiempo_espera:
            self.heuristic_repair_and_objectives_with_tw()
        else:
            self.heuristic_repair()
            self.calcular_objetivos_a_optimizar()

    def quitar_ceros(self):
    # función para quitar los ceros de la ruta antes de volver a hacer la reparación heurísitca
        ruta = self.genes
        self.genes = []
        for elemento in ruta:
            if elemento != 0:
                self.genes.append(elemento)

    def calcular_fitness_final(self, front ,frente_pareto):
    # función que calcula el fitness final de cada individuo
        # primero calculamos el fitness según los frentes del ranking de frente
        dummy_fitness = 100
        # distancia de máxima tal que los demas elementos dentro degradarán a este elemento
        # pongo este valor porque el tiempo_total_vehiculos está inicialmente en el rango [20000-28000]
        fitness_sharing_dist = 30
        # de esta manera de acuerdo al frente en el que están tendrán un mayor o menor valor de fitness
        self.fitness = dummy_fitness/front
        # ahora realizamos la degradación de nicho o fitness sharing (cuantos más individuos tenga a su alrededor menor fitness)
        # coordenadas en el frente pareto de este individuo
        indiv = [self.cantidad_vehiculos, self.tiempo_total_vehiculos]
        n = 1
        for ind_vecino in frente_pareto:
            # coordenadas en el frente Pareto de la función vecina
            vecino = [ind_vecino.cantidad_vehiculos, ind_vecino.tiempo_total_vehiculos]
            if (vecino != indiv):
                if (math.dist( indiv, vecino ) <= fitness_sharing_dist):
                    n += 1
        # se produce la degradación en base a la cantidad de vecinos cercanos
        self.fitness = self.fitness/n
        
    def get_fitness_objetivos(self):
    # retorna los dos valores de fitness del individuo: cantidad de vehiculos y la suma de los tiempos de cada vehículo
        return self.cantidad_vehiculos, self.tiempo_total_vehiculos

    def get_ruta(self):
    # retorna la ruta del individuo
        return self.genes

    def normalizar_tiempo(self):
    # dividiremos el tiempo entre 1000 para que no sea un valor tan lejano a cantidad de vehículos
        self.tiempo_total_vehiculos /= 100

    def volver_a_tiempo_verdadero(self):
    # volvemos al valor original de tiempo multiplicandolo por 1000
        self.tiempo_total_vehiculos *= 100

    def __init__(self, depot_data, clients_data, max_capacity):
        self.clients_data = clients_data
        self.depot_data = depot_data
        self.max_capacity = max_capacity
        self.fitness = 0
        self.genes = []
        # iniciamos esta variable en 1 porque en la función de fitness vamos sumando cada vez que aparece un nuevo vehículo
        # por lo que no se tiene en cuenta el primer vehículo
        self.cantidad_vehiculos = 1;
        self.tiempo_total_vehiculos = 0;
        # comento lo de abajo porque me parece mejor llamarlos fuera del init
        # self.generate_random_individual()
        # self.heuristic_repair_and_fitness()
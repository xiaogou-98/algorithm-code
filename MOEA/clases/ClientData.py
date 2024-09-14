import math
class ClientData(object):
    def __init__(self, client_number, x, y, demand, ready_time, due_date, service_time):
        self.client_number = client_number
        self.x = x
        self.y = y
        self.demand = demand
        self.ready_time = ready_time
        self.due_date = due_date
        self.service_time = service_time
        self.is_depot = self.client_number == 0

    def get_distance_to_client(self, client):
        client_a = [self.x, self.y]
        client_b = [client.x, client.y]
        return math.dist( client_a, client_b ) #Calculate the euclidean distance between points

    def get_demand(self):
        return self.demand

    def timepoint_is_in_the_window(self, timepoint):
        start = timepoint
        end = timepoint + self.service_time
        return start >= self.ready_time and end <= self.due_date 
    
    def timepoint_is_before(self, timepoint):
        return timepoint < self.ready_time

    def can_serve_in_timepoint(self, timepoint):
        return self.timepoint_is_in_the_window(timepoint) or self.timepoint_is_before(timepoint)
import random as rand

class IdFactory:

    @staticmethod
    def create_numeric_id(length) -> int:
        exp = 1
        result = 0
        for i in range(length):
            rand_num = rand.randint(0, 9)
            result += (rand_num * exp)

            exp *= 10
        
        return result


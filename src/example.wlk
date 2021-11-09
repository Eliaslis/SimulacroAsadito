
class Persona{
	var dieta = vegetariano
	var platosConsumidos = [] 
	var property posicion = 1
	var property criterio = criterioSordo
	var elementosCercanos = []
	
	method recibirElemento(elemento){
		elementosCercanos.add(elemento)
	}
	
	method verificarElemento(elemento){
		elementosCercanos.add(elemento)
	}
	
	method peticion(elemento,alguien){
		alguien.verificarElemento(elemento)
		alguien.criterio().realizarPeticion(elemento,alguien,self)
	}
	
	method elementos() = elementosCercanos
	
	method primerElemento() = elementosCercanos.first()
	
	method aceptarComida(comida){
		dieta.verificacionComida(comida)
		self.aniadirComidaConsumida(comida)
	}
	
	method aniadirComidaConsumida(comida){
		platosConsumidos.add(comida)
	}
	
	method pipon() = platosConsumidos.any({comida => comida.esPesada()})
	
	method laEstaPasandoBien(){
		return platosConsumidos.size() >= 1 and (osky.cumpleCondicion() or moni.cumpleCondicion() or facu.cumpleCondicion() or vero.cumpleCondicion()) 
	}
	
	method platosConsumidos() = platosConsumidos
}

object osky inherits Persona{
	method cumpleCondicion() = true
}

object moni inherits Persona{
	method cumpleCondicion() = self.posicion() == 1
}

object facu inherits Persona{
	
	method cumpleCondicion() = self.platosConsumidos().filter({plato => plato.esCarne()}).size() >= 1
}

object vero inherits Persona{
	method cumpleCondicion() = self.elementos().size() < 3	
}

object criterioSordo{
	
	method realizarPeticion(elemento,emisor,receptor){
		receptor.recibirElemento(emisor.primerElemento())
	}
}

object criterioTranquilo{
	
	method realizarPeticion(elemento,emisor,receptor){
		
		emisor.elementos().forEach({elem => receptor.recibirElemento(elem)})
	}
}

object criterioPosicion{
	method realizarPeticion(elemento,emisor,receptor){
		emisor.posicion(receptor.posicion())
		receptor.posicion(emisor.posicion())
	}
}

object criterioElemento{
	method realizarPeticion(elemento,emisor,receptor){
		receptor.recibirElemento(elemento)
	}
}

class Comida{
	const calorias = 100
	const esCarne = true
	
	method calorias() = calorias
	method esCarne() = esCarne
	method esPesada() = calorias > 500
}

object vegetariano{
	method verificacionComida(comida){
		if(not comida.esCarne()){
			return true
		} 
		else{
			throw new DomainException(message = "No consume carne")
		} 
	}
}

object dietetico{
	method verificacionComida(comida) = comida.calorias() < 500
}

object alternado{
	var aceptar = false
	
	method verificacionComida(comida){
		if(aceptar){
			aceptar = false
			return false
		}
		else{
			aceptar = true
			return true
		}
	}
}

object combinado{
	method verificacionComida(comida) = vegetariano.verificacionComida(comida) && dietetico.verificacionComida(comida) && alternado.verificacionComida(comida)
} 
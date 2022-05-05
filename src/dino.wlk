import wollok.game.*
    
const velocidad = 250

object juego{

	method configurar(){
		game.width(12)
		game.height(8)
		game.title("Dino Game")
		game.addVisual(suelo)
		game.addVisual(cactus)
		game.addVisual(dino)
		game.addVisual(banana)
		//game.addVisual(reloj)
		game.addVisual(sol)
		game.boardGround("rio-del-bosque.jpg")
		
	
		keyboard.space().onPressDo{ self.jugar()}
		keyboard.s().onPressDo{self.bananacomida()}
		game.onCollideDo(dino,{ obstaculo => obstaculo.chocar()})
		game.onCollideDo(dino,{ banana => banana.comida() })
		
	} 
	
	method iniciar(){
		dino.iniciar()
		//reloj.iniciar()
		cactus.iniciar()
		banana.iniciar()
	
	}
	method bananacomida(){
		if (dino.estaVivo()) 
			dino.supersalto()
		else {
			game.removeVisual(gameOver)
			self.iniciar()
		}
	}
	
	method jugar(){
		if (dino.estaVivo()) 
			dino.saltar()
		else {
			game.removeVisual(gameOver)
			self.iniciar()
		}
		
	}
	
	method terminar(){
		game.addVisual(gameOver)
		cactus.detener()
		//reloj.detener()
		dino.morir()
		banana.detener()
	}
	
}

object gameOver {
	method position() = game.center()
	method text() = "GAME OVER"
	

}

/* object reloj {
	
	var tiempo = 0
	
	method text() = tiempo.toString()
	method position() = game.at(1, game.height()-1)
	
	method pasarTiempo() {
		tiempo = tiempo +1
	}
	method iniciar(){
		tiempo = 0
		game.onTick(100,"tiempo",{self.pasarTiempo()})
	}
	method detener(){
		game.removeTickEvent("tiempo")
	}
} */
object sol {
	method image () = "sol-removebg-preview.png"
	method position() = game.at(1, game.height()-2)
}

object cactus {
	 
	const posicionInicial = game.at(game.width()-1,suelo.position().y())
	var position = posicionInicial

	method image() = "gorila_animado-removebg-preview.png"
	method position() = position
	
	method iniciar(){
		position = posicionInicial
		game.onTick(velocidad,"moverCactus",{self.mover()})
	}
	
	method mover(){
		position = position.left(1)
		if (position.x() == -1)
			position = posicionInicial
	}
	method comida(){}
	method chocar(){
		juego.terminar()
	}
    method detener(){
		game.removeTickEvent("moverCactus")
	}
}

object suelo{
	
	method position() = game.origin().up(0)
	
	method image() = "suelo.png"
}


object dino {
	var vivo = true
	var position = game.at(1,suelo.position().y())
	
	method image() = "tarzan-removebg-preview.png"
	method position() = position
	
	method saltar(){
		if(position.y() == suelo.position().y()) {
			self.subir()
			game.schedule(velocidad*3,{self.bajar()})
		}
	}
	/*method comibanana(){
		if ()
	}*/
	method supersalto(){
		if(position.y() == suelo.position().y()) {
			self.supersubir()
			game.schedule(velocidad*3,{self.superbajar()})
	}
	}
	
	method supersubir (){
		position = position.up(3)
	}
	method subir(){
		position = position.up(1)
	}
	method superbajar(){
		position = position.down(3)
	}
	method bajar(){
		position = position.down(1)
	}
	method morir(){
		game.say(self,"¡Auch!")
		vivo = false
	}
	method iniciar() {
		vivo = true
	}
	method estaVivo() {
		return vivo 
	}
}
object banana{
	var comerla = false
	const posicionInicial = game.at(0.randomUpTo(24).truncate(0),suelo.position().y())
	var position = posicionInicial

	method image() = "bananass-removebg-preview.png"
	method position() = position
	 
	method iniciar(){
		position = posicionInicial
		game.onTick(velocidad,"moverBanana",{self.mover()})
	}
	
	method mover(){
		position = position.left(1)
		if (position.x() == -1)
			position = posicionInicial
	}
	method comida(){
		juego.bananacomida()     
	}
	method chocar(){
		game.say(self,"Que rico")
		comerla = true
	}

	 method detener(){
		game.removeTickEvent("moverBanana")
	}
}
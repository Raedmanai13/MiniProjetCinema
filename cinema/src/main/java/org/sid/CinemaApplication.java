package org.sid;

import org.sid.entities.Film;
import org.sid.entities.Salle;
import org.sid.entities.Ticket;
import org.sid.services.ICinemaInitService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.rest.core.config.RepositoryRestConfiguration;
@SpringBootApplication
public class CinemaApplication implements CommandLineRunner {
	@Autowired
	private ICinemaInitService icinemaInitService;
	@Autowired
	private RepositoryRestConfiguration restConfiguration;

	public static void main(String[] args) {
		SpringApplication.run(CinemaApplication.class, args);
	}

	@Override
	public void run(String... args) throws Exception {
		restConfiguration.exposeIdsFor(Film.class,Salle.class,Ticket.class);
		
		icinemaInitService.initVilles();
		icinemaInitService.initCinemas();
		icinemaInitService.initSalles();
		icinemaInitService.initPlaces();
		icinemaInitService.initSeances();
		icinemaInitService.initCategories();
		icinemaInitService.initFilms();
		icinemaInitService.initProjections();
		icinemaInitService.initTickets();

	}

}

package org.sid.entities;


import org.springframework.data.rest.core.config.Projection;

@Projection(name="p2",types = Ticket.class)
public interface TicketProjection {
	public Long getId();
	public String getNomClient();
	public double getPrix();
	public Integer geCodePaiement();
	public boolean getReservee();
	public Place getplace();
}

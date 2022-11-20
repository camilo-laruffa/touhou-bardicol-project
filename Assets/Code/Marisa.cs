using Godot;
using System;

public class Marisa : Node2D
{
	// Declare member variables here. Examples:
	// private int a = 2;
	private float speed = 5f;
	private Vector2 _velocity = new Vector2();

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		GD.Print("hola");
	}
	 public override void _PhysicsProcess(float delta){	  
		manage_input();
	}
	
	private void manage_input(){
		if(Input.IsActionPressed("left")){
			GlobalPosition += new Vector2 (-speed,0);
		}
		if(Input.IsActionPressed("right")){
			GlobalPosition += new Vector2 (speed,0);
		}
		if(Input.IsActionPressed("up")){
			GlobalPosition += new Vector2 (0,-speed);
		}
		if(Input.IsActionPressed("down")){
			GlobalPosition += new Vector2 (0,speed);
		}
		if(Input.IsActionPressed("shoot")){
			shoot();
		}
		if(Input.IsActionPressed("shift")){
			speed = 3f;
		}else{
			speed = 5f;
		}
		
	}
	
	private void shoot(){
		
	}
}

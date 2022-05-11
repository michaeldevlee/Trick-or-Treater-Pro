extends Sprite

var rng = RandomNumberGenerator.new()

func _ready():
	var animationPlayer = get_node("ParticleShineAnim")
	rng.randomize()
	var animSpeed = rng.randf_range(0.5, 1)
	animationPlayer.play("Particle Shine", -1, animSpeed)


/proc/isapostle(mob/living/M)
	return istype(M) && M.mind && M.mind.has_antag_datum(/datum/antagonist/apostle)

/datum/antagonist/apostle
	name = "Apostle Heretic"
	roundend_category = "apostle heretics"
	antagpanel_category = "Apostle Heretic"
	job_rank = "Apostle Heretic"
	antag_hud_type = ANTAG_HUD_SHADOW
	antag_hud_name = "shadowling"
	antag_moodlet = /datum/mood_event/focused
	var/betrayed = FALSE // For one-sin interaction
	show_to_ghosts = TRUE

/datum/antagonist/apostle/New()
	. = ..()
	GLOB.apostles |= src

/datum/antagonist/apostle/proc/prophet_death()
	var/mob/living/carbon/human/H = owner.current
	to_chat(H, "<span class='colossus'>The prophet is dead...</span>")
	H.visible_message("<span class='danger'>[H.real_name] briefly looks above...</span>", "<span class='userdanger'>You see the light above...</span>")
	H.emote("scream")
	H.Immobilize(200)
	addtimer(CALLBACK(src, .proc/soundd_in), 10)

/datum/antagonist/apostle/proc/soundd_in()
	var/mob/living/carbon/human/H = owner.current
	var/turf/T = get_turf(H)
	playsound(H, 'sound/abnormalities/whitenight/apostle_death_final.ogg', 60, TRUE, TRUE)
	new /obj/effect/temp_visual/cult/sparks(T)
	addtimer(CALLBACK(src, .proc/drop_dust), 25)

/datum/antagonist/apostle/proc/drop_dust()
	var/mob/living/carbon/human/H = owner.current
	GLOB.apostles -= src
	for(var/obj/item/W in H)
		if(!H.dropItemToGround(W))
			qdel(W)
	H.dust()

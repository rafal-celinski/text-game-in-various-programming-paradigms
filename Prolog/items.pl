:- discontiguous 
    describe_item/1,
    use_item/1,
    item_at/2.

% V1_ACCESS_CARD
    item_at(reactor, v1_access_card).

% V2_ACCESS_CARD

% ENCYKLOPEDIA
    item_at(medbay, encyklopedia).

    use_item(encyklopedia) :-
        assert(done(encyklopedia)),
        fail.

    describe_item(encyklopedia):-
        write('You open the worn pages of the encyclopedia, flipping through information on various alien species.'), nl,
        write('One entry catches your attention: it describes a species known for its shape-shifting abilities and hostile nature.'), nl,
        write('A critical line reads: "Though formidable, this species has one weakness—intense, direct light can disorient or even harm it."'), nl,
        write('Maybe bringing flashlight to the battelfield wouldn''t be bad idea'), nl.

% FLASHLIGHT
    item_at(security, flashlight).
    
    describe_item(flashlight):-
        write('You don''t know how long will the battery keep up but the light could easily blind someone'), !, nl.

% WRENCH
    item_at(electrical, wrench).

    describe_item(wrench) :-
    write('A sturdy wrench. It could be useful for repairs or as a makeshift weapon.'), nl.

% PLUSHIE
    item_at(storage, plushie).

    describe_item(plushie) :-
    write('A soft, well-loved plushie. It might not be useful, but it could be comforting.'), nl.

% EMPTY_CANISTER
    item_at(storage, empty_canister).

    describe_item(empty_canister) :-
    write('An empty canister that could be refilled with something useful later.'), nl.

% POKEMON CARD
    item_at(storage, brand_new_1995_Pokémon_Limited_Edition_Holographic_Charizard_Card_1st_Edition_Base_Set_with_Gem_Mint_PSA_10_Grading_and_Original_Packaging).

    describe_item(brand_new_1995_Pokémon_Limited_Edition_Holographic_Charizard_Card_1st_Edition_Base_Set_with_Gem_Mint_PSA_10_Grading_and_Original_Packaging) :-
    write('A pristine Pokémon card from 1995 with holographic Charizard—it''s probably worth a fortune!'), nl.

% PETROL_CANISTER
    item_at(storage, petrol_canister).
    
    describe_item(petrol_canister) :-
    write('A heavy canister filled with petrol. It might come in handy if you need fuel.'), nl.

% ROPE
    item_at(storage, rope).

    describe_item(rope) :-
    write('A strong rope that could be useful for climbing or tying things down.'), nl.

% CARTON
    item_at(storage, carton).

    describe_item(carton) :-
    write('An empty carton. Not very useful on its own, but maybe it could hold something.'), nl.

% LIGHTBULBS
    item_at(storage, lightbulbs).

    describe_item(lightbulbs) :-
    write('A box of lightbulbs. They might be useful to replace a broken one.'), nl.

% GAS_CANISTER
    item_at(storage, gas_canister).

    describe_item(gas_canister) :-
    write('A pressurized gas canister. It could be dangerous if used improperly.'), nl.


% SHOTGUN
    item_at(weapons, shotgun).
    
    describe_item(shotgun) :-
    write('A powerful shotgun with a full magazine. It could be your best defense in a fight.'), nl.

% MEDICAL REPORT
    describe_item(medical_report) :-
        write('MEDICAL REPORT'), nl,
        write('--------------'), nl,
        write('Date: 06.04.2124'), nl, nl,
        write('The examined entity is a human.'), nl, nl,
        write('Valid only with v1_access_card.'), nl.


    use_item(Item) :-
        describe_item(Item), !, nl.

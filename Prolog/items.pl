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

% PLUSHIE
    item_at(storage, plushie).

% EMPTY_CANISTER
    item_at(storage, empty_canister).

% POKEMON CARD
    item_at(storage, brand_new_1995_Pokémon_Limited_Edition_Holographic_Charizard_Card_1st_Edition_Base_Set_with_Gem_Mint_PSA_10_Grading_and_Original_Packaging).

% PETROL_CANISTER
    item_at(storage, petrol_canister).

% ROPE
    item_at(storage, rope).

% CARTON
    item_at(storage, carton).

% LIGHTBULBS
    item_at(storage, lightbulbs).

% GAS_CANISTER
    item_at(storage, gas_canister).

% SHOTGUN
    item_at(weapons, shotgun).

% MEDICAL REPORT
    describe_item(medical_report) :-
        write('MEDICAL REPORT'), nl,
        write('--------------'), nl,
        write('Date: 06.04.2124'), nl, nl,
        write('The examined entity is a human.'), nl, nl,
        write('Valid only with v1_access_card.'), nl.


    use_item(Item) :-
        describe_item(Item), !, nl.

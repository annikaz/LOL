:- use_module(library(pce)).


:- dynamic selected_option/2.

% Initialize the selected options with default values
initialize_selected_options :-
    assertz(selected_option(lane, none)),
    assertz(selected_option(dmg, none)),
    assertz(selected_option(type, none)),
    assertz(selected_option(skillLevel, none)).
% similarity metrics for lanes, types and skill levels
similarity(lane,top,top,10).
similarity(lane,top,jungle,6).
similarity(lane,top,mid,8).
similarity(lane,top,adc,4).
similarity(lane,top,support,2).
similarity(lane,jungle,top,6).
similarity(lane,jungle,jungle,10).
similarity(lane,jungle,mid,8).
similarity(lane,jungle,adc,3).
similarity(lane,jungle,support,7).
similarity(lane,mid,top,8).
similarity(lane,mid,jungle,8).
similarity(lane,mid,mid,10).
similarity(lane,mid,adc,4).
similarity(lane,mid,support,6).
similarity(lane,adc,top,4).
similarity(lane,adc,jungle,3).
similarity(lane,adc,mid,4).
similarity(lane,adc,adc,10).
similarity(lane,adc,support,9).
similarity(lane,support,top,2).
similarity(lane,support,jungle,7).
similarity(lane,support,mid,6).
similarity(lane,support,adc,9).
similarity(lane,support,support,10).

similarity(type,mage,mage,10).
similarity(type,mage,fighter,6).
similarity(type,mage,assassin,3).
similarity(type,mage,tank,2).
similarity(type,mage,marksman,3).
similarity(type,mage,support,6).
similarity(type,fighter,mage,6).
similarity(type,fighter,fighter,10).
similarity(type,fighter,assassin,7).
similarity(type,fighter,tank,8).
similarity(type,fighter,marksman,2).
similarity(type,fighter,support,1).
similarity(type,assassin,mage,3).
similarity(type,assassin,fighter,7).
similarity(type,assassin,assassin,10).
similarity(type,assassin,tank,1).
similarity(type,assassin,marksman,2).
similarity(type,assassin,support,1).
similarity(type,tank,mage,2).
similarity(type,tank,fighter,8).
similarity(type,tank,assassin,1).
similarity(type,tank,tank,10).
similarity(type,tank,marksman,1).
similarity(type,tank,support,9).
similarity(type,marksman,mage,3).
similarity(type,marksman,fighter,2).
similarity(type,marksman,assassin,2).
similarity(type,marksman,tank,1).
similarity(type,marksman,marksman,10).
similarity(type,marksman,support,3).
similarity(type,support,mage,6).
similarity(type,support,fighter,1).
similarity(type,support,assassin,1).
similarity(type,support,tank,9).
similarity(type,support,marksman,3).
similarity(type,support,support,10).

similarity(skillLevel,beginner,beginner,10).
similarity(skillLevel,beginner,intermediate,6).
similarity(skillLevel,beginner,advanced,2).
similarity(skillLevel,intermediate,beginner,6).
similarity(skillLevel,intermediate,intermediate,10).
similarity(skillLevel,intermediate,advanced,6).
similarity(skillLevel,advanced,beginner,2).
similarity(skillLevel,advanced,intermediate,6).
similarity(skillLevel,advanced,advanced,10).
% input page
gui :-
    new(Window, frame('LoL Champ Recommender')),
    send(Window, size, size(400,300)),

    new(Dialog, dialog('Selections')),

    new(Lane, dialog_group('Lane')),

    new(Type, dialog_group('Type')),
    new(SkillLevel, dialog_group('SkillLevel')),

    send_list(Lane, append, [
        button(top, message(@prolog, update_selected_option, lane, top)),
        button(jungle, message(@prolog, update_selected_option, lane, jungle)),
        button(mid, message(@prolog, update_selected_option, lane, mid)),
        button(adc, message(@prolog, update_selected_option, lane, adc)),
        button(support, message(@prolog, update_selected_option, lane, support))
    ]),


    send_list(Type, append, [
        button(mage, message(@prolog, update_selected_option, type, mage)),
        button(fighter, message(@prolog, update_selected_option, type, fighter)),
        button(assassin, message(@prolog, update_selected_option, type, assassin)),
        button(tank, message(@prolog, update_selected_option, type, tank)),
        button(marksman, message(@prolog, update_selected_option, type, marksman)),
        button(support, message(@prolog, update_selected_option, type, support))
    ]),

    send_list(SkillLevel, append, [
        button(beginner, message(@prolog, update_selected_option, skillLevel, beginner)),
        button(intermediate, message(@prolog, update_selected_option, skillLevel, intermediate)),
        button(advanced, message(@prolog, update_selected_option, skillLevel, advanced))
    ]),

    new(Button, button('Recommend')),
    send(Button, message, message(@prolog, calculate_recommendation)),

    send(Dialog, append, Lane),
    send(Dialog, append, Type),
    send(Dialog, append, SkillLevel),
    send(Dialog, append, Button),
    send(Dialog, transient_for, Window),
    send(Dialog, open_centered).


update_selected_option(MenuID, Option) :-
    retractall(selected_option(MenuID, _)),
    assertz(selected_option(MenuID, Option)),
    inform_selected_option(MenuID, Option).

inform_selected_option(MenuID, Option) :-
    format('Selected option for ~w: ~w~n', [MenuID, Option]).

% champion stats
hero(aatrox, top, fighter, intermediate).
hero(ahri, mid, mage, intermediate).
hero(akali, mid, assassin, advanced).
hero(akali, top, assassin, advanced).
hero(akshan, mid, marksman, beginner).
hero(alistar, support, tank, advanced).
hero(amumu, jungle, tank, intermediate).
hero(amumu, support, tank, intermediate).
hero(anivia, mid, mage, advanced).
hero(annie, mid, mage, advanced).
hero(aphelios, adc, marksman, advanced).
hero(ashe, adc, marksman, intermediate).
hero(ashe, support, marksman, intermediate).
hero(aurelionsol, mid, mage, advanced).
hero(azir, mid, mage, advanced).
hero(bard, support, support, advanced).
hero(belveth, jungle, fighter, advanced).
hero(blitzcrank, support, tank, intermediate).
hero(brand, mid, mage, intermediate).
hero(brand, jungle, mage, intermediate).
hero(brand, support, mage, intermediate).
hero(braum, support, support, intermediate).
hero(briar, jungle, fighter, intermediate).
hero(caitlyn, adc, marksman, advanced).
hero(camille, top, fighter, intermediate).
hero(camille, support, fighter, intermediate).
hero(cassiopeia, mid, mage, advanced).
hero(chogath, top, tank, intermediate).
hero(corki, mid, marksman, advanced).
hero(darius, top, fighter, beginner).
hero(diana, mid, fighter, intermediate).
hero(diana, jungle, fighter, intermediate).
hero(draven, adc, marksman, advanced).
hero(drmundo, top, fighter, intermediate).
hero(ekko, jungle, assassin, advanced).
hero(ekko, mid, assassin, advanced).
hero(elise, jungle, mage, advanced).
hero(evelynn, jungle, assassin, advanced).
hero(ezreal, adc, marksman, advanced).
hero(ezreal, mid, marksman, advanced).
hero(fiddlesticks, jungle, mage, advanced).
hero(fiora, top, fighter, intermediate).
hero(fizz, mid, assassin, advanced).
hero(galio, support, tank, intermediate).
hero(galio, mid, tank, intermediate).
hero(gangplank, top, fighter, advanced).
hero(garen, mid, fighter, intermediate).
hero(garen, top, fighter, intermediate).
hero(gnar, top, fighter, advanced).
hero(gragas, mid, fighter, intermediate).
hero(gragas, top, fighter, intermediate).
hero(gragas, jungle, fighter, intermediate).
hero(graves, jungle, marksman, intermediate).
hero(gwen, top, fighter, intermediate).
hero(hecarim, jungle, fighter, advanced).
hero(heimerdinger, mid, mage, advanced).
hero(heimerdinger, top, mage, advanced).
hero(heimerdinger, support, mage, advanced).
hero(hwei, mid, mage, advanced).
hero(hwei, support, mage, advanced).
hero(illaoi, top, fighter, intermediate).
hero(irelia, mid, fighter, intermediate).
hero(irelia, top, fighter, intermediate).
hero(ivern, jungle, support, advanced).
hero(janna, support, support, advanced).
hero(jarvaniv, jungle, tank, intermediate).
hero(jax, jungle, fighter, intermediate).
hero(jax, top, fighter, intermediate).
hero(jayce, mid, fighter, advanced).
hero(jayce, top, fighter, advanced).
hero(jhin, adc, marksman, advanced).
hero(jinx, adc, marksman, advanced).
hero(kaisa, adc, marksman, advanced).
hero(kalista, adc, marksman, advanced).
hero(karma, mid, mage, intermediate).
hero(karma, top, mage, intermediate).
hero(karma, support, mage, intermediate).
hero(karthus, jungle, mage, advanced).
hero(kassadin, mid, assassin, advanced).
hero(katarina, mid, assassin, advanced).
hero(kayle, top, fighter, advanced).
hero(kayn, jungle, fighter, advanced).
hero(kennen, top, mage, intermediate).
hero(khazix, jungle, assassin, advanced).
hero(kindred, jungle, marksman, intermediate).
hero(kled, top, fighter, advanced).
hero(kogmaw, adc, marksman, advanced).
hero(ksante, top, tank, advanced).
hero(leblanc, mid, assassin, advanced).
hero(leesin, jungle, fighter, advanced).
hero(leesin, top, fighter, advanced).
hero(leona, support, tank, intermediate).
hero(lillia, jungle, fighter, advanced).
hero(lissandra, mid, mage, advanced).
hero(lucian, adc, marksman, advanced).
hero(lucian, mid, marksman, advanced).
hero(lulu, support, support, intermediate).
hero(lux, mid, mage, intermediate).
hero(lux, support, mage, intermediate).
hero(malphite, top, tank, beginner).
hero(malphite, mid, tank, beginner).
hero(malphite, support, tank, beginner).
hero(malzahar, mid, mage, advanced).
hero(maokai, support, tank, intermediate).
hero(maokai, jungle, tank, intermediate).
hero(masteryi, jungle, assassin, intermediate).
hero(milio, support, support, intermediate).
hero(missfortune, adc, marksman, beginner).
hero(missfortune, support, marksman, beginner).
hero(monkeyking, top, fighter, intermediate).
hero(monkeyking, jungle, fighter, intermediate).
hero(mordekaiser, jungle, fighter, intermediate).
hero(mordekaiser, top, fighter, intermediate).
hero(morgana, mid, mage, beginner).
hero(morgana, support, mage, beginner).
hero(naafiri, mid, assassin, beginner).
hero(nami, support, support, intermediate).
hero(nasus, top, fighter, advanced).
hero(nautilus, support, tank, advanced).
hero(neeko, support, mage, intermediate).
hero(neeko, mid, mage, intermediate).
hero(nidalee, jungle, assassin, advanced).
hero(nilah, adc, fighter, advanced).
hero(nocturne, jungle, assassin, intermediate).
hero(nunu, jungle, tank, intermediate).
hero(olaf, top, fighter, intermediate).
hero(olaf, jungle, fighter, intermediate).
hero(orianna, mid, mage, advanced).
hero(ornn, top, tank, intermediate).
hero(pantheon, mid, fighter, intermediate).
hero(pantheon, support, fighter, intermediate).
hero(pantheon, top, fighter, intermediate).
hero(poppy, support, tank, advanced).
hero(poppy, top, tank, advanced).
hero(poppy, jungle, tank, advanced).
hero(pyke, support, support, advanced).
hero(qiyana, mid, assassin, advanced).
hero(quinn, top, marksman, intermediate).
hero(rakan, support, support, intermediate).
hero(rammus, jungle, tank, intermediate).
hero(reksai, jungle, fighter, intermediate).
hero(reksai, top, fighter, intermediate).
hero(rell, support, tank, beginner).
hero(renata, support, support, advanced).
hero(renekton, mid, fighter, intermediate).
hero(renekton, top, fighter, intermediate).
hero(rengar, jungle, assassin, advanced).
hero(riven, top, fighter, advanced).
hero(rumble, jungle, fighter, advanced).
hero(rumble, top, fighter, advanced).
hero(rumble, support, fighter, advanced).
hero(ryze, mid, mage, advanced).
hero(samira, adc, marksman, advanced).
hero(sejuani, jungle, tank, intermediate).
hero(senna, adc, marksman, advanced).
hero(senna, support, marksman, advanced).
hero(seraphine, support, mage, beginner).
hero(sett, top, fighter, beginner).
hero(shaco, support, assassin, advanced).
hero(shaco, jungle, assassin, advanced).
hero(shen, support, tank, intermediate).
hero(shen, top, tank, intermediate).
hero(shyvana, jungle, fighter, intermediate).
hero(singed, top, tank, intermediate).
hero(sion, top, tank, intermediate).
hero(sivir, adc, marksman, intermediate).
hero(skarner, top, fighter, intermediate).
hero(skarner, support, fighter, intermediate).
hero(skarner, jungle, fighter, intermediate).
hero(smolder, adc, marksman, advanced).
hero(smolder, top, marksman, advanced).
hero(smolder, mid, marksman, advanced).
hero(sona, support, support, intermediate).
hero(soraka, support, support, intermediate).
hero(swain, mid, mage, advanced).
hero(swain, support, mage, advanced).
hero(sylas, mid, mage, intermediate).
hero(sylas, support, mage, intermediate).
hero(sylas, top, mage, intermediate).
hero(sylas, jungle, mage, intermediate).
hero(syndra, mid, mage, advanced).
hero(tahmkench, support, support, intermediate).
hero(tahmkench, top, support, intermediate).
hero(taliyah, mid, mage, intermediate).
hero(taliyah, jungle, mage, intermediate).
hero(talon, jungle, assassin, advanced).
hero(talon, mid, assassin, advanced).
hero(taric, support, support, intermediate).
hero(teemo, jungle, marksman, advanced).
hero(teemo, top, marksman, advanced).
hero(teemo, support, marksman, advanced).
hero(thresh, support, support, advanced).
hero(tristana, mid, marksman, intermediate).
hero(tristana, adc, marksman, intermediate).
hero(trundle, top, fighter, intermediate).
hero(trundle, jungle, fighter, intermediate).
hero(tryndamere, top, fighter, intermediate).
hero(twistedfate, mid, mage, advanced).
hero(twistedfate, top, mage, advanced).
hero(twitch, adc, marksman, advanced).
hero(twitch, support, marksman, advanced).
hero(udyr, jungle, fighter, advanced).
hero(udyr, top, fighter, advanced).
hero(urgot, top, fighter, advanced).
hero(varus, adc, marksman, beginner).
hero(vayne, adc, marksman, advanced).
hero(vayne, top, marksman, advanced).
hero(veigar, adc, mage, advanced).
hero(veigar, mid, mage, advanced).
hero(veigar, support, mage, advanced).
hero(velkoz, support, mage, advanced).
hero(velkoz, mid, mage, advanced).
hero(vex, mid, mage, beginner).
hero(vi, jungle, fighter, intermediate).
hero(viego, jungle, assassin, intermediate).
hero(viktor, mid, mage, advanced).
hero(vladimir, mid, mage, advanced).
hero(vladimir, top, mage, advanced).
hero(volibear, jungle, fighter, intermediate).
hero(volibear, top, fighter, intermediate).
hero(warwick, top, fighter, intermediate).
hero(warwick, jungle, fighter, intermediate).
hero(xayah, adc, marksman, intermediate).
hero(xerath, mid, mage, advanced).
hero(xerath, support, mage, advanced).
hero(xinzhao, jungle, fighter, beginner).
hero(yasuo, adc, fighter, advanced).
hero(yasuo, mid, fighter, advanced).
hero(yasuo, top, fighter, advanced).
hero(yone, mid, assassin, advanced).
hero(yone, top, assassin, advanced).
hero(yorick, top, fighter, advanced).
hero(yuumi, support, support, beginner).
hero(zac, support, tank, advanced).
hero(zac, top, tank, advanced).
hero(zac, jungle, tank, advanced).
hero(zed, jungle, assassin, advanced).
hero(zed, mid, assassin, advanced).
hero(zeri, adc, marksman, advanced).
hero(ziggs, adc, mage, intermediate).
hero(ziggs, mid, mage, intermediate).
hero(zilean, support, support, advanced).
hero(zoe, mid, mage, intermediate).
hero(zyra, support, mage, advanced).



hero_similarity(Hero1,Lane1,Type1,SkillLevel1,Lane,Type,SkillLevel,Similarity) :-
    hero(Hero1, Lane1, Type1, SkillLevel1),
    similarity(lane,Lane1,Lane,Similarity1),
    similarity(type,Type1,Type,Similarity2),
    similarity(skillLevel,SkillLevel1,SkillLevel,Similarity3),
    Similarity is 3 * Similarity1 + 2 * Similarity2 + Similarity3.





calculate_recommendation :-
    selected_option(lane, Lane),
    selected_option(type, Type),
    selected_option(skillLevel, SkillLevel),
    hero_similarity(Hero1, Lane1,Type1,SkillLevel1,Lane, Type, SkillLevel, Similarity),
    hero_similarity(Hero2, Lane2,Type2,SkillLevel2,Lane, Type, SkillLevel, Similarity2),
    \+ (hero_similarity(_, _,_,_,Lane, Type, SkillLevel, Similarity3), Similarity3 > Similarity),
    Hero1 \= Hero2,
    \+ (hero_similarity(Hero4,_,_,_, Lane, Type, SkillLevel, Similarity4), Hero4 \= Hero1, Similarity4 > Similarity2),
    format('Recommended Champions: Champion 1: ~w (~w, ~w, ~w); Champion 2: ~w (~w, ~w, ~w)~n', [Hero1, Lane1, Type1, SkillLevel1, Hero2, Lane2, Type2, SkillLevel2]).
:- initialize_selected_options,
    gui.


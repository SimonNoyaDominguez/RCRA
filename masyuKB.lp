%Autor: Simon Noya Dominguez

% Reglas del rompecabezas Masyu
% Tamaño del rompecabezas
size(n).
%#const n=3. black(0). white(5).
%#const n=6. black(0;12;26). white(10;13;22;23;31;34).
%#const n=6. black(7;22;35). white(4;9;11;21;25;29;31).
%#const n=8. black(2;7;19;30;39;49;62). white(1;8;27;32;35).
%#const n=10. black(64;70;99). white(1;6;12;15;17;18;21;28;30;32;35;42;45;48;53;59;72;77;81;85;86;87).
%#const n=15. black(9;10;12;15;61;69;89;96;101;105;115;135;138;143;145;148;154;160;171;173;185;212;219;224). white(5;18;19;21;29;32;37;48;51;54;57;65;71;78;79;80;84;110;112;114;132;140;142;152;178;181;183;202;206;216;222).
%#const n=20. black(3;17;36;49;52;65;94;102;104;106;131;142;154;173;175;188;207;209;240;251;260;268;274;286;287;295;301;334;383). white(10;21;29;31;42;47;58;59;73;81;88;91;92;98;101;109;117;118;120;123;137;143;146;148;149;165;177;181;182;183;190;204;206;215;217;218;224;226;233;236;237;243;252;253;259;264;270;278;290;292;307;310;312;317;324;325;328;330;337;341;345;352;358;360;365;369;376;389;392;396;398).
%#const n=25. black(2;7;14;56;70;73;76;83;88;111;112;117;124;129;148;162;178;220;226;232;240;249;269;272;280;289;310;327;353;354;356;364;386;388;395;398;421;422;450;468;486;496;502;505;509;512;516;518;521;526;544;552;598;612;614). white(4;34;36;41;44;46;58;79;96;105;108;118;125;127;131;146;158;160;164;167;170;181;185;187;190;191;194;195;198;200;208;209;211;213;217;230;233;237;242;244;245;256;259;283;287;290;294;306;319;326;331;333;337;341;349;359;368;376;383;391;394;396;402;415;429;431;433;434;437;438;458;461;464;466;473;478;483;484;489;503;536;549;554;557;564;568;575;579;580;583;584;591;611;617).

% Definimos todos los puntos
punto(0..n*n-1).

%Definimos las filas y columnas
row(0..n-1).
col(0..n-1).


%Definimos los valores de una cordenada.
coordenate((X,Y),P):- punto(P), row(X), col(Y), X=P/n, Y=P\n,  P=P.

%Reglas de adjacencia
adjacencia(P,P'):- punto(P), punto(P'), coordenate(C,P), coordenate(C',P'), adjacencia_coor(C,C').
adjacencia_coor((X,Y), (X,Y+1)):-row(X), col(Y), col(Y+1).
adjacencia_coor((X,Y), (X+1,Y)):-row(X), row(X+1), col(Y).

%Creacion de segmentos
{seg(P,P')} :- adjacencia(P,P').

% Cada punto debe tener exactamente dos segmentos
:- white(P), #count{Q:seg(P,Q)} = C1, #count{Q:seg(Q,P)} = C2, C1+C2!=2.
:- black(B), #count{Q:seg(B,Q)} = C1, #count{Q:seg(Q,B)} = C2, C1+C2!=2.

:- seg(P,P'), #count{Q:seg(P,Q), Q!=P'} = C1, #count{Q:seg(Q,P)} = C2, #count{Q:seg(P',Q)} = C3, #count{Q:seg(Q,P'), Q!=P} = C4, C1+C2+C3+C4!=2.


%Definimos un punto minimo desde el cual comprobar que todos lo segmentos estan conectados
punto_minimo_white(P):-#min{Q:white(Q)}=P.
punto_minimo_black(P):-#min{Q:black(Q)}=P.

punto_minimo(W):-punto_minimo_white(W), punto_minimo_black(B), W<B.
punto_minimo(B):-punto_minimo_white(W), punto_minimo_black(B), W>B.

reach(P):-punto_minimo(P).

reach(P'):- punto_minimo(P), seg(P,P').
reach(P'):- punto_minimo(P), seg(P',P).

reach(P''):- reach(P'), seg(P'',P').
reach(P''):- reach(P'), seg(P',P'').

%Debe haber un único ciclo.
:- white(W), not reach(W).
:- black(B), not reach(B).


%Definimos que es una curva en el punto p.
curva_en_p(F,P,S) :-  seg(F,P), seg(P,S), coordenate((X,Y),P), coordenate((X1,Y1),F), coordenate((X2,Y2),S), X1=X2. 
curva_en_p(F,P,S) :-  seg(F,P), seg(P,S), coordenate((X,Y),P), coordenate((X1,Y1),F), coordenate((X2,Y2),S), Y1=Y2.

%Definimos un punto de curva.
curva(P):- punto(P), not curva_en_p(_,P,_).

%Los círculos blancos deben atravesarse en línea recta
:- coordenate((X,Y),P), white(P), seg(P,F), seg(P,S), coordenate((X1,Y1),F), coordenate((X2,Y2),S), Y1!=Y2, X1!=X2.
:- coordenate((X,Y),P), white(P), seg(F,P), seg(P,S), coordenate((X1,Y1),F), coordenate((X2,Y2),S), Y1!=Y2, X1!=X2.
:- coordenate((X,Y),P), white(P), seg(F,P), seg(S,P), coordenate((X1,Y1),F), coordenate((X2,Y2),S), Y1!=Y2, X1!=X2.

%Los círculos negros no pueden atravesarse en línea recta
:- coordenate((X,Y),P), black(P), seg(F,P), seg(P,S), coordenate((X1,Y),F), coordenate((X2,Y),S), X1!=X2.
:- coordenate((X,Y),P), black(P), seg(F,P), seg(P,S), coordenate((X,Y1),F), coordenate((X,Y2),S), Y1!=Y2.

%Tras un circulo negro  no puede haber una curva
:-black(P), seg(P,P'), curva(P').
:-black(P), seg(P',P), curva(P').

%En un circulo blanco se debe girar antes o despues, o em ambos sitios.
:-white(W), seg(F,W), seg (W,S), not curva(F) ; not curva(S).

#show seg/2.
%#show curva/1.

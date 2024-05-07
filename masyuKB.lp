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



% Definimos todos los puntos
punto(0..n*n-1).

%Definimos las filas y columnas
row(0..n-1).
col(0..n-1).

%Definimos los valores de una cordenada.
%Definimos que coordenadas son blam¡ncas y cuales negras, blanco=0, negro=1, resto<0.
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
minpoint_white(P):-#min{Q:white(Q)}=P.
minpoint_black(P):-#min{Q:black(Q)}=P.

minpoint(W):-minpoint_white(W), minpoint_black(B), W<B.
minpoint(B):-minpoint_white(W), minpoint_black(B), W>B .

connected(P):-minpoint(P).

connected(P'):- minpoint(P), seg(P,P').
connected(P'):- minpoint(P), seg(P',P).

connected(P''):- connected(P'), seg(P'',P').
connected(P''):- connected(P'), seg(P',P'').

%Debe haber un único ciclo.
:- white(W), not connected(W).
:- black(B), not connected(B).

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

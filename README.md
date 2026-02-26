18. Path finding in a Maze (70%+)

Feladat:

Ez a feladat párhuzamos útkereső algoritmusok GPU-n történő megvalósítására összpontosít labirintusokban vagy rácsalapú környezetekben, beleértve a fejlett forgatókönyvek vizualizációját és feltárását.

Kulcsfontosságú (maximum 70%):
Párhuzamos szélességi keresés (BFS) vagy Dijkstra algoritmus megvalósítása GPU-n a legrövidebb út megtalálása érdekében egy egyszerű 2D-s rácsban/labirintusban. A kihívás a hullámfront-kiterjesztés hatékony kezelése a GPU-n. Az útvonal vizualizációja szükséges.

Párhuzamos BFS vagy Dijkstra algoritmus megvalósítása a GPU-n: (30%)
Hullámfront-kiterjesztés hatékony kezelése a GPU-n: (20%)
A megtalált útvonal valós idejű vizualizációja: (20%)
[0% interoperáció és memóriamegosztás nélkül]]
Középhaladó:
Hajlékonyabb útkereső algoritmusok, például A* keresés kezelése vagy párhuzamos labirintusgeneráló algoritmusok feltárása (pl. Kruskal vagy Prim algoritmusa minimális feszítőfákhoz, labirintusokhoz adaptálva). Ez magában foglalná a nyitott és zárt listák hatékony kezelését a GPU-n, és potenciálisan a szabálytalan gráfstruktúrák kezelését.
A* keresés megvalósítása a GPU-n: (+20%)
Párhuzamos labirintusgeneráló algoritmus (pl. Kruskal vagy Prim) megvalósítása: (+10%)
Haladó:
Útvonalkeresés megvalósítása dinamikus környezetekben, ahol az akadályok elmozdulhatnak vagy megjelenhetnek/eltűnhetnek, ami újraszámítást igényel. Egy másik haladó lehetőség lehet a többágenses útvonalkeresés, ahol több entitásnak kell útvonalakat találnia anélkül, hogy ütköznének egymással, olyan technikákat használva, mint az áramlási mezők vagy a lokális ütközés elkerülése a GPU-n.

Útvonalkeresés megvalósítása dinamikus környezetben újraszámítással: (+20%)

Többágenses útvonalkeresés megvalósítása ütközés elkerüléssel (pl. áramlási mezők vagy lokális ütközés elkerülése): (+10%)
Adatszerkezetek és memória-hozzáférés optimalizálása dinamikus vagy többágenses forgatókönyvekhez: (+10%)

Nagy gráf algoritmusok gyorsítása a GPU-n CUDA használatával
CUDA megoldások az SSSP problémára
A* keresési algoritmus - Wikipédia

Terv:

Nyelv: CUDA
Adatszerkezet: Mátrix(struct-ok mátrixa) ahol van csúcs az struct ahol nincs az nullptr
Algoritmus: BFS (Később lehet dijkstra lesz belőle)
Struct elemei: Távolság(d), Szülő(p)


Kérdések: 
Mi a fasz az a hullámfront?
Lehet-e ugyanolyan hosszúságú utaknak más súlya?


22. Parallel Sorting Algorithms on the GPU (up to 95%)

Feladat:
Különböző párhuzamos rendező algoritmusok (pl. Bitonikus rendezés, Összevonásos rendezés, Radix rendezés) megvalósítása és optimalizálása a GPU-n, különös tekintettel a megosztott/helyi memória és munkacsoportok használatára a hatékony adatkezelés és a szálak közötti kommunikáció érdekében.

Feladatok:
Egy alapvető párhuzamos rendezési algoritmus (pl. egyszerű párhuzamos összevonásos rendezés vagy páros-páratlan rendezés) megvalósítása a GPU-n (25%).
A kiválasztott rendezési algoritmus optimalizálása a megosztott/helyi memória hatékony használatával altömbök rendezéséhez vagy munkacsoportokon belüli egyesítési műveletekhez (30%).
Egy fejlettebb párhuzamos rendezési algoritmus (pl. Bitonikus rendezés vagy Radix rendezés) megvalósítása, amely eredendően kihasználja a munkacsoport-szintű párhuzamosságot és a megosztott/helyi memóriát az adatmozgatáshoz és összehasonlításokhoz (30%).
A megosztott/helyi memória és munkacsoportok használatával elért teljesítményelőnyök elemzése és dokumentálása, beleértve a CPU-rendezési algoritmusokkal való összehasonlításokat is (10%).

Terv:

Nyelv: CUDA
Adatszerkezet: Tömb
Algoritmus: minden is


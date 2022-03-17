# inverted_index (P04 -  CCOS 264 Information retrieval)

A tool for CCOS 264 (Information retrieval). :)

Usage:

Get files from https://github.com/ivanmoreau/prep_textos

```bash
ivanmolinarebolledo@Ivans-macOS inverted_index % stack run -- --help                                                      
The invertedindex program

invertedindex [COMMAND] ... [OPTIONS]

Common flags:
  -? --help         Display help message
  -V --version      Print version information

invertedindex model [OPTIONS]

  -f --from=ITEM  
  -t --to=ITEM    

invertedindex query [OPTIONS]

  -o --ogfile=ITEM
  -m --model=ITEM 
  -q --query=ITEM 
ivanmolinarebolledo@Ivans-macOS inverted_index %
```

Query examples:

```bash
ivanmolinarebolledo@Ivans-macOS inverted_index % stack run -- query -o="Tweets.txt" -m="mm.ths" -q="cama museo" 
[201] @JaAC9510 tweeted: Hoy me niego a levantarme de mi cama (W: 0.3535534)
[16] @yosoyloagui tweeted: Tu y yo juntos en un lugar perfectollamado mi cama *.* (W: 0.3162278)
[13] @LuisGcortez tweeted: Parece que falta algo de atención y mantenimiento al museo de la ciudad por parte del @ICAdifusion http://t.co/FLbC5SbcoF (W: 0.28867513)
ivanmolinarebolledo@Ivans-macOS inverted_index % stack run -- query -o="Tweets.txt" -m="mm.ths" -q="invito novio"
[82] @Fea_situ_fea tweeted: "Y si te invito a una copa y me acerco a tu boca..." ♫ (W: 0.28867513)
[49] @KarlyyRG tweeted: Nada mejor que tener un novio super divertido que en lugar de limitarte, te sigue el pedo. (W: 0.28867513)
[42] @KarlyyRG tweeted: Lo que mas me encanta de mi novio es que me hace morir de risa. (W: 0.28867513)
[186] @Andresrgtz tweeted: Mi amiga se besó a una mujer muy sexi el fin de semana no le digan a su novio (W: 0.25)
[11] @oscarponce82 tweeted: LOS INVITO A SEGUIR A MI CARNAL @losprimosjavier CANTANTE DE @PRIMOSMX ARRIBA DURANGO CABRONES!!🔫🔫🔫🔫🔫 http://t.co/AgA0JIoSjF (W: 0.19759141)
[5] @NayeliTun tweeted: RT @oscarponce82: LOS INVITO A SEGUIR A MI CARNAL @losprimosjavier CANTANTE DE @PRIMOSMX ARRIBA DURANGO CABRONES!!🔫🔫🔫🔫🔫 http://t.co/AgA0JIo… (W: 0.19030122)
ivanmolinarebolledo@Ivans-macOS inverted_index % stack run -- query -o="Tweets.txt" -m="mm.ths" -q="vida riesgo dios"
[206] @alex_dsr01 tweeted: Ni pedo la vida es un riesgo -Fergus (W: 0.2581989)
[203] @abrilushiZ tweeted: RT @_equiswe: Si Dios me quita la vida antes que a ti... (W: 0.2581989)
[87] @rolix1210 tweeted: @elyvakeva @SChecoPerez crees que llegue su primera victoria esta temporada? (W: 0.2581989)
[152] @almayurifan tweeted: no es un adios siplemente un hasta luego y dejemos que Dios junto con el destino hagan lo que se tenga que hacer... http://t.co/6l3pNd1J2Y (W: 0.21821788)
[301] @raulpacheco tweeted: @carlosbravoreg @samnbk Dios. Mio. Por eso estamos como estamos. Carajo. PS - me encanto tu articulo sobre "parachuting journalism" (W: 0.20412415)
[129] @arqhenson tweeted: Chingao, hoy no voy a poder ir a la novillada, pero espero sea un gran festejo como cada domingo, dios reparta suerte! (W: 0.19245009)
[345] @CaballoNegroII tweeted: RT @MyRyCaR: Gracias por tu presencia en mi vida...un regalo de Dios 😆 teee amooo @CaballoNegroII http://t.co/grQRS43NK1 (W: 0.18257418)
ivanmolinarebolledo@Ivans-macOS inverted_index % stack run -- query -o="Tweets.txt" -m="mm.ths" -q="tortillas hombre feliz"
[69] @PiernasAlLomo tweeted: @La_Montserrat a las tortillas? (W: 0.4082483)
[236] @nichelopezc tweeted: Hoy ni la pizza me hace feliz carajo!!' (W: 0.28867513)
[265] @fantasmaluigui tweeted: Siempre recuerda: No tomes decisiones cuando estés enojado, y no hagas promesas cuando estés feliz. (W: 0.20412415)
[171] @AlanMorayra tweeted: Se acerca la mejor Feria de México así es La Feria de Aguascalientes y el Hombre araña ya esta listo Lol  Lol! http://t.co/BVyG9Rcsij (W: 0.18257418)
[109] @zubyelynl tweeted: Hola feliz domingo tengan tod@s hoy les presento esta capa o poncho que se puede usar tanto en temporada de frio... http://t.co/qh1xeinf22 (W: 0.18257418)
[57] @isabel_demetrio tweeted: X meter a un hombre me  andan tanteando huiyuyiuuuiiii k miedosos jajajajajajaja (W: 0.18257418)
[52] @isabel_demetrio tweeted: X keeeeerer a un hombre me andan tanteando uyuyuiiii k miedo jajajajjajajaj (W: 0.18257418)
[325] @123anotaz tweeted: RT @CarlaMorrAgs: La mujer es una obra de arte que ilumina los ojos de quien la mira. Feliz Dia de la Mujer @CarlaMorrisonmx ♥ (W: 0.17407766)
[303] @OhMariah_ tweeted: Por fin, a las 7:00 pm, me acaban de felicitar por el día de la mujer.Ya estaba empezando a creer que yo en realidad era hombre. (W: 0.17407766)
ivanmolinarebolledo@Ivans-macOS inverted_index % stack run -- query -o="Tweets.txt" -m="mm.ths" -q="amiga novio"
[186] @Andresrgtz tweeted: Mi amiga se besó a una mujer muy sexi el fin de semana no le digan a su novio (W: 0.5)
[339] @melendez_sasa tweeted: @diana_devela y eso porque amiga,no lo vas a ver (W: 0.4082483)
[49] @KarlyyRG tweeted: Nada mejor que tener un novio super divertido que en lugar de limitarte, te sigue el pedo. (W: 0.28867513)
[42] @KarlyyRG tweeted: Lo que mas me encanta de mi novio es que me hace morir de risa. (W: 0.28867513)
[341] @CcXochitl tweeted: https://t.co/z0q9xuMSEMjajajajaja ok yo le enseñare a mi amiga a bailar asi alguiien... http://t.co/cj09zQotDa (W: 0.26726124)
```
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: VocationalTestScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class VocationalTestScreen extends StatefulWidget {
  @override
  _VocationalTestScreenState createState() => _VocationalTestScreenState();
}

class _VocationalTestScreenState extends State<VocationalTestScreen> {
  List<int> answers = [2, 2, 2]; // Respostas padrão
  String userName = '';

  void updateAnswer(int index, int value) {
    setState(() {
      answers[index] = value;
    });
  }

  bool canShowResult() {
    return userName.isNotEmpty;
  }

  String getInterestArea() {
    int artisticScore = answers[0];
    int logicalScore = answers[1];
    int collaborativeScore = answers[2];

    // Lógica simples para determinar a área de interesse com base nas respostas
    if (artisticScore > logicalScore && artisticScore > collaborativeScore) {
      return 'Artes e Criatividade';
    } else if (logicalScore > artisticScore && logicalScore > collaborativeScore) {
      return 'Lógica e Matemática';
    } else {
      return 'Trabalho Colaborativo';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Teste Vocacional'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Olá! Complete o teste vocacional para descobrir sua área de interesse.',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Digite seu nome:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            TextField(
              onChanged: (value) {
                setState(() {
                  userName = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Digite seu nome',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            QuestionCard(
              question:
              'Em uma escala de 1 a 5, o quanto você se identifica com atividades que envolvem habilidades artísticas e criativas?',
              scale: ConcordanceScale(
                selectedIndex: answers[0],
                onChanged: (value) => updateAnswer(0, value),
              ),
            ),
            QuestionCard(
              question:
              'Em uma escala de 1 a 5, o quanto você se sente confortável em lidar com desafios lógicos e matemáticos?',
              scale: ConcordanceScale(
                selectedIndex: answers[1],
                onChanged: (value) => updateAnswer(1, value),
              ),
            ),
            QuestionCard(
              question:
              'Em uma escala de 1 a 5, o quanto você se vê trabalhando em um ambiente colaborativo, onde o trabalho em equipe é valorizado?',
              scale: ConcordanceScale(
                selectedIndex: answers[2],
                onChanged: (value) => updateAnswer(2, value),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: canShowResult()
                  ? () {
                String interestArea = getInterestArea();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TestResultScreen(
                      userName: userName,
                      interestArea: interestArea,
                    ),
                  ),
                );
              }
                  : null,
              child: Text('Ver Resultado'),
            ),
          ],
        ),
      ),
    );
  }
}

class QuestionCard extends StatelessWidget {
  final String question;
  final Widget scale;

  QuestionCard({required this.question, required this.scale});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // Centralizar o conteúdo
          children: [
            Text(
              question,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center, // Alinhar o texto ao centro
            ),
            SizedBox(height: 10),
            scale,
          ],
        ),
      ),
    );
  }
}

class ConcordanceScale extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  ConcordanceScale({required this.selectedIndex, required this.onChanged});

  @override
  _ConcordanceScaleState createState() => _ConcordanceScaleState();
}

class _ConcordanceScaleState extends State<ConcordanceScale> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap: () {
            widget.onChanged(index);
          },
          child: ConcordanceBall(
            isSelected: index == widget.selectedIndex,
            sizeFactor: 1 + 0.2 * (2 - index).abs(),
            color: index == 2 ? Colors.yellow : index > 2 ? Colors.blue : Colors.red,
          ),
        );
      }),
    );
  }
}

class ConcordanceBall extends StatelessWidget {
  final bool isSelected;
  final double sizeFactor;
  final Color color;

  ConcordanceBall({required this.isSelected, required this.sizeFactor, required this.color});

  @override
  Widget build(BuildContext context) {
    double baseSize = 20.0;
    double adjustedSize = baseSize * sizeFactor;

    return Container(
      width: adjustedSize,
      height: adjustedSize,
      margin: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 2),
        color: isSelected ? color.withOpacity(0.5) : Colors.transparent,
      ),
    );
  }
}

class TestResultScreen extends StatelessWidget {
  final String userName;
  final String interestArea;

  TestResultScreen({required this.userName, required this.interestArea});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resultado do Teste Vocacional'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Olá $userName! Parabéns por completar o teste vocacional.',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Baseado nas suas respostas, parece que você tem um grande potencial na área de tecnologia e inovação! 🌟',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Aqui estão algumas sugestões de cursos e carreiras que podem combinar com seus interesses e habilidades:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Cursos Recomendados:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('- Desenvolvimento de Software: Aprenda a criar aplicativos e programas que transformam ideias em realidade digital.'),
            Text('- Ciência de Dados: Explore o mundo dos dados e descubra como extrair insights valiosos para tomar decisões informadas.'),
            Text('- Engenharia de Computação: Desenvolva habilidades em hardware e software para construir sistemas computacionais avançados.'),
            Text('- Design Digital e UX/UI: Crie interfaces intuitivas e envolventes para aplicativos e sites.'),
            SizedBox(height: 10),
            Text(
              'Possíveis Carreiras:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('- Desenvolvedor de Software: Construa e mantenha aplicativos e sistemas de software.'),
            Text('- Analista de Dados: Transforme dados em informações significativas para empresas.'),
            Text('- Engenheiro de Sistemas: Projete e desenvolva soluções tecnológicas inovadoras.'),
            Text('- Designer de Experiência do Usuário (UX/UI): Crie interfaces amigáveis e visualmente atraentes.'),
            SizedBox(height: 20),
            Text(
              'Próximos Passos:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('- Exploração: Pesquise mais sobre essas áreas e veja qual delas mais te intriga.'),
            Text('- Cursos e Certificações: Considere iniciar cursos online ou certificações relacionadas.'),
            Text('- Estágios e Projetos: Participe de estágios ou comece projetos próprios para ganhar experiência prática.'),
            SizedBox(height: 20),
            Text(
              'Lembre-se, sua jornada é única e o mais importante é seguir algo que te inspire e te desafie. Estamos aqui para apoiá-lo em cada passo do caminho. Boa sorte na sua jornada rumo à tecnologia! 🚀',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

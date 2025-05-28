import 'package:anshinpet/configs/theme/app_colors.dart';
import 'package:anshinpet/res/components/appbar_custom.dart';
import 'package:anshinpet/res/components/bottom_navigation_bar_custom.dart';
import 'package:anshinpet/res/components/drawer_custom.dart';
import 'package:anshinpet/view_model/animal_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AnimalPage extends StatefulWidget {
  const AnimalPage({super.key});

  @override
  State<AnimalPage> createState() => _AnimalPageState();
}

class _AnimalPageState extends State<AnimalPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchData());
  }
  
  void _fetchData() {
    context.read<AnimalViewModel>().fetchAnimals();
  }

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    final animalProvider = Provider.of<AnimalViewModel>(context);
    final animals = animalProvider.animals;
    final isLoading = animalProvider.loading;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppbarCustom(),
      drawer: DrawerCustom(),
      body: isLoading
        ? const Center(child: CircularProgressIndicator())
        : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02, vertical: screenWidth * 0.02),
            child: const Text(
              "Animais",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w400,
                color: AppColors.primary
              ),
            ),
          ),
          const Divider(),
          Expanded(
            child: animals.isEmpty
              ? const Center(child: Text('Nenhum animal encontrado.'))
              :GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.8, //proporção dos itens
              ),
              itemCount: animals.length,
              itemBuilder: (context, index) {
                final animal = animals[index];
                return Container(
                  margin: EdgeInsets.all(screenWidth * 0.02),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(screenWidth * 0.02),
                          child: Text(animal.nome ?? 'Sem nome'),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network('https://anshinpet-api-bc75c527a28e.herokuapp.com/api/animais/${animal.id}/foto',
                             width: screenWidth * 0.1,
                             fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(screenWidth * 0.1),
                          child: ElevatedButton(onPressed: () {}, child: Text('Ver mais'), style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                          ),),  
                        )
                      ],
                    ),
                  )
                );
              },
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBarCustom(valueIndex: 0,),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: CircleBorder(),
        child: Icon(Icons.add),
        ),
    );
  }
}

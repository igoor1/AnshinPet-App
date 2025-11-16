import 'package:anshinpet/configs/theme/app_colors.dart';
import 'package:anshinpet/data/app_exceptions.dart';
import 'package:anshinpet/model/animal_model.dart';
import 'package:anshinpet/resources/components/appbar_custom.dart';
import 'package:anshinpet/resources/components/drawer_custom.dart';
import 'package:anshinpet/resources/components/animal_card.dart'; 
import 'package:anshinpet/resources/components/animal_card_skeleton.dart';
import 'package:anshinpet/viewmodels/animal_view_model.dart';
import 'package:anshinpet/viewmodels/auth_view_model.dart';
import 'package:anshinpet/viewmodels/token_view_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:anshinpet/view/animals/new_animal_page.dart';
import 'package:anshinpet/view/animals/animal_detail_page.dart';

class AnimalPage extends StatefulWidget {
  const AnimalPage({super.key});

  @override
  State<AnimalPage> createState() => _AnimalPageState();
}

class _AnimalPageState extends State<AnimalPage> {
  String? _token;

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadInitialData());

    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    final tokenModel = await context.read<TokenViewModel>().getToken();
    if (!mounted) return;
    setState(() {
      _token = tokenModel.token;
    });

    if (_token != null) {
      await _fetchData(); 
    } else {
      if (mounted) {
        await Provider.of<AuthViewModel>(context, listen: false).logout(context);
      }
    }
  }

  Future<void> _fetchData() async {
    try {
      await context.read<AnimalViewModel>().fetchAllAnimals();
    } on UnauthorizedException catch (_) {
      if (mounted) {
        await Provider.of<AuthViewModel>(context, listen: false).logout(context);
      }
    } catch (e) {
      if (kDebugMode) print("Erro ao buscar animais: $e");
    }
  }

  void _openAddAnimalPage() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const NewAnimalPage()))
        .then((_) {
          _fetchData();
          _searchFocusNode.unfocus();
        });
  }

  Future<void> _openDetail(AnimalModel animal) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => AnimalDetailPage(animal: animal)),
    );
    _searchFocusNode.unfocus();
    await _fetchData();
  }

  Widget _buildError(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 60),
            const SizedBox(height: 16),
            const Text(
              'Ocorreu um Erro:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: const TextStyle(color: Colors.red, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final animalProvider = context.watch<AnimalViewModel>();

    final List<AnimalModel> allAnimals = animalProvider.animals;
    final isLoading = animalProvider.loading;
    final error = animalProvider.error;

    final filteredAnimals = allAnimals.where((animal) {
      final name = animal.name?.toLowerCase() ?? '';
      return name.contains(_searchQuery.toLowerCase());
    }).toList();

    final bool isCriticalLoading = _token == null; 
    
    final bool showSkeleton = isLoading && filteredAnimals.isEmpty;

    Widget listContent;

    if (isCriticalLoading) {
      listContent = const Center(child: CircularProgressIndicator());
    } else if (error != null) {
      listContent = _buildError(error);
    } else {
      
      if (showSkeleton) {
        listContent = ListView.builder(
            padding: const EdgeInsets.only(bottom: 80, top: 8, right: 8, left: 8),
            itemCount: 4, 
            itemBuilder: (context, index) {
              return const AnimalCardSkeleton();
            },
        );
      } else if (filteredAnimals.isEmpty) {
        listContent = Center(
            child: Text(
                _searchQuery.isEmpty
                    ? 'Nenhum animal cadastrado.'
                    : 'Nenhum animal encontrado para "$_searchQuery"',
                textAlign: TextAlign.center,
            ),
        );
      } else {
        listContent = RefreshIndicator(
            onRefresh: _fetchData,
            child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 80, top: 8, right: 8, left: 8),
                itemCount: filteredAnimals.length,
                itemBuilder: (context, index) {
                    final animal = filteredAnimals[index];
                    return AnimalCard(
                        animal: animal,
                        token: _token,
                        onTap: () => _openDetail(animal),
                    );
                },
            ),
        );
      }
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppbarCustom(),
      drawer: DrawerCustom(),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04,
                vertical: screenWidth * 0.02,
              ),
              child: const Text(
                "Animais",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: TextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                decoration: InputDecoration(
                  hintText: 'Buscar por nome...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 2.0,
                    ),
                  ),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            _searchFocusNode.unfocus();
                          },
                        )
                      : null,
                ),
              ),
            ),

            Expanded(
              child: isCriticalLoading ? listContent : listContent,
            ),
          ],
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddAnimalPage,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
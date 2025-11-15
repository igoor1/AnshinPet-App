import 'package:anshinpet/model/vaccine_model.dart';
import 'package:anshinpet/view/vaccine/vaccine_edit_page.dart';
import 'package:flutter/material.dart';

class VaccineCard extends StatelessWidget {
  final VaccineModel vaccine;

  const VaccineCard({
    super.key,
    required this.vaccine,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => {
        Navigator.push(
          context, 
          MaterialPageRoute(
            builder: (context) => VaccineEditPage(vaccine: vaccine)
          )
        )
      },
      child: Card(
        elevation: 2.0,
        shadowColor: Colors.deepPurple.shade50, 
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.healing_outlined,
                    color: Color.fromRGBO(124, 84, 217, 1),
                    size: 18.0,
                  ),
                  const SizedBox(width: 8.0),
                  Flexible(
                    child: Text(
                      vaccine.name,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(124, 84, 217, 1),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const Divider(
                height: 24.0,
                thickness: 0.5,
                color: Color.fromARGB(255, 230, 221, 248), 
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [ 
                  Expanded(
                    child: Row(
                      children: [
                        Icon(
                          Icons.factory_outlined,
                          size: 16.0,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 6.0),
                        Flexible(
                          child: Text(
                            vaccine.producer,
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.grey.shade700,
                            ),
                            overflow: TextOverflow.ellipsis,
                          )
                        )
                      ],
                    )
                  ),
                  Text(
                    'Ver mais',
                    style: TextStyle(
                      fontWeight: FontWeight.w600
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'package:animate_do/animate_do.dart';

import 'package:cinemapedia/domain/entities/actor.dart';

class ActorsHorizontalListview extends StatelessWidget {
  final List<Actor> actors;

  const ActorsHorizontalListview({
    super.key,
    required this.actors,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textStyles = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text("Cast", style: textStyles.titleLarge),
        ),
        SizedBox(
          height: 360,
          child: ListView.builder(
            itemCount: actors.length,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final actor = actors[index];

              return FadeInRight(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          actor.profilePath,
                          height: 300,
                          width: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(actor.name, style: textStyles.titleMedium),
                      if (actor.character != null)
                        Text(
                          actor.character!,
                          style: textStyles.bodyMedium?.copyWith(
                            color: colors.secondary,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

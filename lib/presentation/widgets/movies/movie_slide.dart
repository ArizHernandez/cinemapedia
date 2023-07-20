import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:go_router/go_router.dart';

class MovieSlide extends StatelessWidget {
  final Movie movie;

  const MovieSlide({
    super.key,
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;

    final moviePopularity = HumanFormats.numberCompact(movie.popularity);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 160,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                movie.posterPath,
                width: 160,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return FadeIn(
                      child: GestureDetector(
                          onTap: () => context.push('/movie/${movie.id}'),
                          child: child),
                    );
                  }

                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 5),
          SizedBox(
            width: 150,
            child: Text(movie.title, style: textStyles.titleSmall),
          ),
          Row(
            children: [
              Icon(
                Icons.star_half_rounded,
                color: Colors.yellow.shade700,
              ),
              const SizedBox(width: 5),
              Text(
                movie.voteAverage.toString(),
                style: textStyles.bodyMedium?.copyWith(
                  color: Colors.yellow.shade800,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                moviePopularity,
                style: textStyles.bodyMedium,
              ),
            ],
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:go_router/go_router.dart';

import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/config/helpers/human_formats.dart';

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
                height: 240,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return FadeIn(
                      child: GestureDetector(
                          onTap: () =>
                              context.push('/home/0/movie/${movie.id}'),
                          child: child),
                    );
                  }

                  return Image.asset(
                    'assets/loaders/bottle-loader.gif',
                    width: 160,
                    height: 240,
                    fit: BoxFit.cover
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 5),
          SizedBox(
            width: 150,
            child: Text(
              movie.title,
              style: textStyles.titleSmall
                  ?.copyWith(overflow: TextOverflow.ellipsis),
              maxLines: 2,
            ),
          ),
          Row(
            children: [
              Icon(
                Icons.star_half_rounded,
                color: Colors.yellow.shade700,
              ),
              const SizedBox(width: 5),
              Text(
                HumanFormats.numberCompact(movie.voteAverage, 2),
                style: textStyles.bodyMedium?.copyWith(
                  color: Colors.yellow.shade800,
                ),
              ),
              const SizedBox(
                width: 60,
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

import 'package:flutter/material.dart';
import 'package:flutter_cep/models/cep_model.dart';

class AddressWidget extends StatelessWidget {
  final CepModel? address;

  const AddressWidget({super.key, this.address});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (address == null) {
      return SizedBox.shrink();
    }

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.primary,
                theme.colorScheme.secondary,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Icon(
                Icons.check_circle_rounded,
                size: 48,
                color: Colors.white,
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                'CEP Encontrado!',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                ),
              ),
              Text(
                'Informações do endereço',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        _InfoCard(
          icon: Icons.location_on_rounded,
          title: 'CEP',
          subtitle: address!.cep,
          color: theme.colorScheme.primary,
        ),
        _InfoCard(
          icon: Icons.streetview_rounded,
          title: 'Logradouro',
          subtitle: address!.logradouro,
          color: theme.colorScheme.secondary,
        ),
        _InfoCard(
          icon: Icons.home_rounded,
          title: 'Bairro',
          subtitle: address!.bairro,
          color: theme.colorScheme.tertiary,
        ),
        _InfoCard(
          icon: Icons.location_city_rounded,
          title: 'Cidade',
          subtitle: address!.localidade,
          color: Color(0xff10b981),
        ),
        _InfoCard(
          icon: Icons.map_rounded,
          title: 'Estado',
          subtitle: address!.estado,
          color: Colors.orange,
        ),
        if (address!.complemento.isNotEmpty)
          _InfoCard(
            icon: Icons.info_rounded,
            title: 'Complemento',
            subtitle: address!.complemento,
            color: Colors.purple,
          ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        spacing: 16,
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

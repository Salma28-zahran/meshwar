import 'package:country_state_city/country_state_city.dart' as csc;
import 'package:customer_app/features/cityto/data/location_option.dart';

abstract final class LocationService {
  LocationService._();

  static Future<List<LocationOption>> getLocations() async {
    try {
      final countries = await csc.getAllCountries();
      final cities = await csc.getAllCities();

      final countryNames = {
        for (final country in countries)
          country.isoCode: country.name,
      };

      final locations = <LocationOption>[
        ...countries.map(
              (country) => LocationOption(
            name: country.name,
            countryName: '',
            displayName: country.name,
            isCountry: true,
          ),
        ),

        ...cities.map(
              (city) {
            final countryName =
                countryNames[city.countryCode] ?? '';

            return LocationOption(
              name: city.name,
              countryName: countryName,
              displayName: countryName.isEmpty
                  ? city.name
                  : '${city.name}, $countryName',
              isCountry: false,
            );
          },
        ),
      ];

      locations.sort(
            (a, b) => a.name.toLowerCase().compareTo(
          b.name.toLowerCase(),
        ),
      );

      return locations;
    } catch (_) {
      return [];
    }
  }
}
# Rotomeca.Core

[![NuGet version](https://img.shields.io/nuget/v/Rotomeca.Core)](https://www.nuget.org/packages/Rotomeca.Core)
[![License: ISC](https://img.shields.io/badge/License-ISC-blue.svg)](https://opensource.org/licenses/ISC)
[![.NET](https://img.shields.io/badge/.NET-netstandard2.0%20%7C%20netstandard2.1%20%7C%20net8%20%7C%20net9%20%7C%20net10-512BD4)](https://dotnet.microsoft.com)

Méta-package C# qui regroupe les briques fondamentales de l'écosystème Rotomeca :
**collections fonctionnelles** (`RArray<T>`) et **type optionnel** (`MayBe<T>`).

Un seul `dotnet add` pour disposer de l'ensemble du socle `Rotomeca.Core.*`.

## Installation

```bash
dotnet add package Rotomeca.Core
```

> Installe automatiquement `Rotomeca.Core.Collections` et `Rotomeca.Core.Optionals` comme dépendances transitives.

---

## Compatibilité

| Environnement | Support                                          |
| ------------- | ------------------------------------------------ |
| .NET Standard | 2.0, 2.1                                         |
| .NET          | 8.0, 9.0 (10.0 si SDK disponible)               |
| Source Link   | ✅ (via les packages sous-jacents)               |
| Symbols       | ✅ (`.snupkg` via les packages sous-jacents)     |
| Nullable      | ✅ (activé)                                      |

---

## Packages inclus

### `Rotomeca.Core.Collections` 1.0.0

Collection `RArray<T>` qui expose l'API des tableaux JavaScript —
**mutateurs**, **transformations fonctionnelles** et **copies immuables** —
sous forme d'une interface fluide et fortement typée.

```csharp
using Rotomeca.Core.Collections;

var result = new RArray<int>(3, 1, 4, 1, 5)
    .Sort()
    .Reverse()
    .Filter(x => x > 2)
    .Map(x => x * 10);
// → [50, 40, 30]
```

---

### `Rotomeca.Core.Optionals` 1.0.1

Type optionnel `MayBe<T>` qui représente une valeur **présente** ou **absente**,
pour tout `T` y compris dans les contextes génériques sans contrainte où `T?` ne suffit pas.
Une valeur `null` est toujours traitée comme **absente**.

```csharp
using Rotomeca.Core.Optionals;

MayBe<string> Find<T>(int id) { ... }

var result = Find<string>(42);
string fallback = result.GetValueOrDefault("inconnu");
```

---

## Démarrage rapide — usage combiné

```csharp
using Rotomeca.Core.Collections;
using Rotomeca.Core.Optionals;

// Recherche sûre dans un tableau
RArray<string> noms = new RArray<string>("Alice", "Bob", "Charlie");

MayBe<string> trouvé = noms.Find(n => n.StartsWith("B"));
Console.WriteLine(trouvé.GetValueOrDefault("Inconnu")); // → Bob

// Transformation avec valeurs optionnelles
var résultats = new RArray<int>(1, 2, 3, 4, 5)
    .Map<MayBe<string>>(x => x % 2 == 0 ? $"pair:{x}" : MayBe<string>.Null)
    .Filter(m => m.HasValue)
    .Map(m => m.Value!);
// → ["pair:2", "pair:4"]
```

---

## Ecosystème Rotomeca

| Package | Description |
| ------- | ----------- |
| [`Rotomeca.Core.Collections`](https://www.nuget.org/packages/Rotomeca.Core.Collections) | Collection `RArray<T>` — API JavaScript pour C# |
| [`Rotomeca.Core.Optionals`](https://www.nuget.org/packages/Rotomeca.Core.Optionals) | Type optionnel `MayBe<T>` |
| [`Rotomeca.`](https://www.nuget.org/packages?q=Rotomeca&includeComputedFrameworks=true&prerel=true) | Tout les packages de l'environnement |

---

## Licence

[ISC](https://opensource.org/licenses/ISC) © Rotomeca

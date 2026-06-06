<div align="center">
<img height="90" alt="rotomeca-lib-csharp" src="https://raw.githubusercontent.com/rotomeca-libs/projects-pictures/494cadd82673710c227e454c08cabc41d089e0f8/rotomeca-lib-csharp.svg" />

# Rotomeca.Core

[![NuGet version](https://img.shields.io/nuget/v/Rotomeca.Core)](https://www.nuget.org/packages/Rotomeca.Core)
[![License: ISC](https://img.shields.io/badge/License-ISC-blue.svg)](https://opensource.org/licenses/ISC)
[![.NET](https://img.shields.io/badge/.NET-netstandard2.0%20%7C%20netstandard2.1%20%7C%20net8%20%7C%20net9%20%7C%20net10-512BD4)](https://dotnet.microsoft.com)

Méta-package C# qui regroupe les briques fondamentales de l'écosystème Rotomeca :
**collections fonctionnelles** (`RArray<T>`) et **type optionnel** (`MayBe<T>`).

Un seul `dotnet add` pour disposer de l'ensemble du socle `Rotomeca.Core.*`.

</div>

---

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

### [`Rotomeca.Core.Collections`](https://www.nuget.org/packages/Rotomeca.Core.Collections) `1.0.0`

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

→ [Documentation complète](https://github.com/rotomeca-libs/core-collections-csharp)

---

### [`Rotomeca.Core.Optionals`](https://www.nuget.org/packages/Rotomeca.Core.Optionals) `1.0.1`

Type optionnel `MayBe<T>` qui représente une valeur **présente** ou **absente**,
pour tout `T` y compris dans les contextes génériques sans contrainte où `T?` ne suffit pas.
Une valeur `null` est toujours traitée comme **absente**.

```csharp
using Rotomeca.Core.Optionals;

MayBe<string> Find<T>(int id) { ... }

var result = Find<string>(42);
if (result.HasValue)
    Console.WriteLine(result.Value);

string fallback = result.GetValueOrDefault("inconnu");
```

→ [Documentation complète](https://github.com/rotomeca-libs/core-optionals-csharp)

---

## Démarrage rapide — usage combiné

`RArray<T>` et `MayBe<T>` sont conçus pour fonctionner ensemble naturellement :

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

// Déconstruction
var (hasValue, value) = trouvé;
if (hasValue)
    Console.WriteLine(value); // → Bob
```

---

## Ecosystème Rotomeca

> Voir la liste complète sur [rotomeca-libs](https://github.com/rotomeca-libs) et les packages C# sur [github](https://github.com/orgs/rotomeca-libs/repositories?q=csharp) ou sur [nuget](https://www.nuget.org/packages?q=Rotomeca&includeComputedFrameworks=true&prerel=true&sortby=relevance)

| Package | Description |
| ------- | ----------- |
| [`Rotomeca.Core.Collections`](https://www.nuget.org/packages/Rotomeca.Core.Collections) | Collection `RArray<T>` — API JavaScript pour C# |
| [`Rotomeca.Core.Optionals`](https://www.nuget.org/packages/Rotomeca.Core.Optionals) | Type optionnel `MayBe<T>` |
| [`Rotomeca.Rop`](https://www.nuget.org/packages/Rotomeca.Rop) | Railway Oriented Programming — `Result<T,E>` |

---

## Contribuer

```bash
git clone https://github.com/rotomeca-libs/core-csharp.git
cd core-csharp
dotnet restore
```

Les contributions sont les bienvenues via Pull Request sur la branche `dev`.

---

## Note sur l'utilisation de l'IA

L'intégralité du code de ce projet a d'abord été écrite à la main en essayant d'avoir le C# le plus propre possible. L'IA a ensuite été utilisée pour :

- **Proposer des axes d'amélioration et de refactorisation** si besoin, après relecture de ses modifications par mes soins
- **La documentation et les README** → j'ai toujours été une bille en documentation, je trouve celle de l'IA lisible et explicite ; elle a toujours été relue et validée par mes soins
- **Les tests unitaires** → tester, c'est facile, mais présenter des tests unitaires, c'est complexe (de mon point de vue) ; l'IA a dans un premier temps généré les tests, je les ai parcourus pour les comprendre et les corriger au besoin
- **La CI/CD** → vu que ce n'est pas mon domaine, mais ça permet d'apprendre beaucoup 👍

Sa principale contribution a donc été de m'accompagner sur les points qui me sont lacunaires.

---

## Licence

[ISC](LICENSE) © Rotomeca

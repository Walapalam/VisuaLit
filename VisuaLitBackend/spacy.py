import spacy
import fitz  # PyMuPDF for PDF processing
from ebooklib import epub
from bs4 import BeautifulSoup
import re
from collections import defaultdict, Counter
import os
import ssl

# Try to fix SSL certificate issues for downloads
try:
    _create_unverified_https_context = ssl._create_unverified_context
except AttributeError:
    pass
else:
    ssl._create_default_https_context = _create_unverified_https_context


class BookAnalyzer:
    def __init__(self):
        # Define our own stopwords instead of using NLTK
        self.stop_words = {
            'i', 'me', 'my', 'myself', 'we', 'our', 'ours', 'ourselves', 'you',
            'your', 'yours', 'yourself', 'yourselves', 'he', 'him', 'his',
            'himself', 'she', 'her', 'hers', 'herself', 'it', 'its', 'itself',
            'they', 'them', 'their', 'theirs', 'themselves', 'what', 'which',
            'who', 'whom', 'this', 'that', 'these', 'those', 'am', 'is', 'are',
            'was', 'were', 'be', 'been', 'being', 'have', 'has', 'had', 'having',
            'do', 'does', 'did', 'doing', 'a', 'an', 'the', 'and', 'but', 'if',
            'or', 'because', 'as', 'until', 'while', 'of', 'at', 'by', 'for',
            'with', 'about', 'against', 'between', 'into', 'through', 'during',
            'before', 'after', 'above', 'below', 'to', 'from', 'up', 'down', 'in',
            'out', 'on', 'off', 'over', 'under', 'again', 'further', 'then', 'once',
            'here', 'there', 'when', 'where', 'why', 'how', 'all', 'any', 'both',
            'each', 'few', 'more', 'most', 'other', 'some', 'such', 'no', 'nor',
            'not', 'only', 'own', 'same', 'so', 'than', 'too', 'very', 's', 't',
            'can', 'will', 'just', 'don', 'should', 'now'
        }

        self.character_descriptors = {
            'appearance': ['look', 'appear', 'tall', 'short', 'thin', 'fat', 'skinny', 'plump',
                           'hair', 'eye', 'face', 'skin', 'complexion', 'beard', 'mustache',
                           'scar', 'glasses', 'spectacles', 'nose', 'ears', 'teeth', 'lips',
                           'chin', 'cheek', 'forehead', 'brow', 'eyebrow', 'lashes', 'freckles'],
            'clothing': ['wear', 'dress', 'robe', 'cloak', 'hat', 'coat', 'jacket', 'shirt',
                         'trousers', 'pants', 'jeans', 'shoes', 'boots', 'clothes', 'uniform',
                         'attire', 'costume', 'garment', 'outfit', 'suit', 'tie', 'scarf', 'gloves'],
            'accessories': ['wand', 'staff', 'cane', 'sword', 'knife', 'dagger', 'ring', 'necklace',
                            'amulet', 'jewelry', 'bracelet', 'watch', 'belt', 'crown', 'tiara',
                            'brooch', 'pin', 'emblem', 'badge', 'medal', 'pendant', 'earring'],
            'expressions': ['smile', 'grin', 'frown', 'scowl', 'grimace', 'laugh', 'cry', 'weep',
                            'glare', 'stare', 'gaze', 'look', 'expression', 'face', 'countenance',
                            'emotion', 'mood', 'feeling', 'demeanor', 'manner', 'attitude']
        }

        self.scene_descriptors = {
            'appearance': ['dark', 'light', 'bright', 'dim', 'gloomy', 'shadowy', 'sunny', 'cloudy',
                           'foggy', 'misty', 'hazy', 'clear', 'colorful', 'vibrant', 'dull', 'dreary',
                           'bleak', 'stark', 'vivid', 'faded', 'worn', 'new', 'ancient', 'modern'],
            'structure': ['room', 'hall', 'castle', 'tower', 'building', 'house', 'cottage', 'mansion',
                          'palace', 'temple', 'church', 'cathedral', 'chamber', 'corridor', 'passageway',
                          'staircase', 'stairs', 'balcony', 'terrace', 'porch', 'courtyard', 'cellar',
                          'dungeon', 'attic', 'basement', 'entrance', 'exit', 'doorway', 'archway'],
            'landscape': ['forest', 'woods', 'jungle', 'mountain', 'hill', 'valley', 'meadow', 'field',
                          'garden', 'park', 'lake', 'river', 'stream', 'creek', 'ocean', 'sea', 'shore',
                          'beach', 'coast', 'cliff', 'desert', 'wasteland', 'swamp', 'marsh', 'bog'],
            'details': ['wall', 'ceiling', 'floor', 'window', 'door', 'carpet', 'rug', 'tapestry',
                        'curtain', 'drape', 'furniture', 'chair', 'table', 'desk', 'bed', 'bookshelf',
                        'fireplace', 'hearth', 'lamp', 'candle', 'torch', 'statue', 'painting',
                        'portrait', 'carving', 'ornament', 'decoration', 'pillar', 'column']
        }

        # Expand descriptor lists to include related forms (plural, -ing, -ed forms)
        self.all_character_descriptors = set()
        for descriptors in self.character_descriptors.values():
            self.all_character_descriptors.update(descriptors)
            # Add common variations (plural, etc.)
            for word in list(descriptors):
                self.all_character_descriptors.add(word + 's')
                self.all_character_descriptors.add(word + 'ed')
                self.all_character_descriptors.add(word + 'ing')

        self.all_scene_descriptors = set()
        for descriptors in self.scene_descriptors.values():
            self.all_scene_descriptors.update(descriptors)
            # Add common variations
            for word in list(descriptors):
                self.all_scene_descriptors.add(word + 's')
                self.all_scene_descriptors.add(word + 'ed')
                self.all_scene_descriptors.add(word + 'ing')

    def extract_text(self, file_path):
        """Extract text from a TXT, PDF, or ePub file."""
        text = ""
        file_path = str(file_path).lower()

        try:
            # Extract text from TXT
            if file_path.endswith(".txt"):
                with open(file_path, "r", encoding="utf-8") as f:
                    text = f.read()

            # Extract text from PDF
            elif file_path.endswith(".pdf"):
                doc = fitz.open(file_path)
                for page in doc:
                    text += page.get_text("text") + " "

            # Extract text from ePub
            elif file_path.endswith(".epub"):
                book = epub.read_epub(file_path)
                content = []
                for item in book.get_items():
                    if isinstance(item, epub.EpubHtml):
                        soup = BeautifulSoup(item.get_content(), "html.parser")
                        content.append(soup.get_text())
                text = " ".join(content)

            else:
                raise ValueError(f"Unsupported file format: {file_path}")

        except Exception as e:
            print(f"Error extracting text: {str(e)}")
            return ""

        # Clean the text: remove excessive whitespace and normalize
        text = re.sub(r'\s+', ' ', text).strip()

        return text

    def preprocess_text(self, text):
        """Preprocess the text for better entity extraction - our own implementation without NLTK."""
        # Custom sentence tokenizer
        # Split on end of sentence punctuation followed by whitespace and uppercase letter
        sentence_patterns = [
            r'(?<=[.!?])\s+(?=[A-Z])',  # Standard end of sentence
            r'(?<=\.\")\s+(?=[A-Z])',  # End quote with period
            r'(?<=\!\")\s+(?=[A-Z])',  # End quote with exclamation
            r'(?<=\?\")\s+(?=[A-Z])',  # End quote with question
            r'\n\n+',  # Multiple newlines as paragraph breaks
        ]

        # Apply each pattern to split text
        sentences = [text]
        for pattern in sentence_patterns:
            new_sentences = []
            for sentence in sentences:
                splits = re.split(pattern, sentence)
                new_sentences.extend(splits)
            sentences = new_sentences

        # Clean sentences
        cleaned_sentences = []
        for sentence in sentences:
            # Remove unwanted characters
            sentence = re.sub(r'[^\w\s.,;:!?"\'-]', '', sentence)
            # Normalize whitespace
            sentence = re.sub(r'\s+', ' ', sentence).strip()
            if len(sentence) > 10:  # Only keep sentences of meaningful length
                cleaned_sentences.append(sentence)

        return cleaned_sentences

    def identify_key_entities(self, text, sample_size=300000):
        """Identify important characters and locations in the text."""
        # Use a sample to identify key entities if text is very long
        sample_text = text[:min(len(text), sample_size)]
        sample_doc = nlp(sample_text)

        # Count entity occurrences
        entity_counts = Counter()
        entity_types = {}

        for ent in sample_doc.ents:
            if ent.label_ in ["PERSON", "GPE", "LOC", "FAC", "ORG"]:
                # Normalize entity name
                name = self._normalize_entity_name(ent.text)
                if name:
                    entity_counts[name] += 1
                    entity_types[name] = ent.label_

        # Use frequency threshold to identify main entities
        character_threshold = 3  # Minimum occurrences for a character
        location_threshold = 2  # Minimum occurrences for a location

        main_characters = {name for name, count in entity_counts.items()
                           if entity_types.get(name) == "PERSON" and count >= character_threshold}

        main_locations = {name for name, count in entity_counts.items()
                          if entity_types.get(name) in ["GPE", "LOC", "FAC", "ORG"] and count >= location_threshold}

        # Find potential character name variations and group them
        character_groups = self._group_character_names(main_characters, entity_counts)

        return character_groups, main_locations

    def _normalize_entity_name(self, name):
        """Normalize entity names by removing titles and extra whitespace."""
        name = re.sub(r'^\s*(Mr\.|Mrs\.|Ms\.|Dr\.|Prof\.|Sir|Lady|Lord)\s+', '', name)
        name = re.sub(r'\s+', ' ', name).strip()
        # Filter out very short names or names with numbers
        if len(name) < 2 or re.search(r'\d', name):
            return None
        return name

    def _group_character_names(self, character_names, entity_counts):
        """Group character names that likely refer to the same person."""
        # Split names into first and last names
        name_parts = {}
        for name in character_names:
            parts = name.split()
            if len(parts) > 0:
                name_parts[name] = parts

        # Group names by last name or first name
        groups = defaultdict(list)
        for name, parts in name_parts.items():
            if len(parts) > 1:
                # Use last name as group key
                groups[parts[-1]].append(name)
            else:
                # Single name
                groups[parts[0]].append(name)

        # Merge groups that have overlap
        merged_groups = []
        processed = set()

        for key, names in groups.items():
            if key in processed:
                continue

            current_group = set(names)
            processed.add(key)

            # Find related groups
            for other_key, other_names in groups.items():
                if other_key in processed or other_key == key:
                    continue

                # Check if groups share any names
                if any(name in current_group for name in other_names):
                    current_group.update(other_names)
                    processed.add(other_key)

            merged_groups.append(current_group)

        # For each group, select the most common name as representative
        character_groups = {}
        for group in merged_groups:
            if not group:
                continue
            # Find the most frequent name in the group
            most_common = max(group, key=lambda name: entity_counts.get(name, 0))
            character_groups[most_common] = list(group)

        return character_groups

    def extract_character_contexts(self, sentences, character_names):
        """Extract sentences that meaningfully describe characters."""
        character_contexts = defaultdict(list)

        for sentence in sentences:
            sentence_lower = sentence.lower()

            # Check if sentence contains any descriptive terms
            has_descriptor = any(word in sentence_lower for word in self.all_character_descriptors)
            if not has_descriptor:
                continue

            # Check if the sentence mentions any character
            for main_name, variations in character_names.items():
                for name in variations:
                    name_pattern = r'\b' + re.escape(name) + r'\b'
                    if re.search(name_pattern, sentence, re.IGNORECASE):
                        # Sentence mentions this character and has descriptive content
                        character_contexts[main_name].append(sentence)
                        break

        return character_contexts

    def extract_scene_contexts(self, sentences, location_names):
        """Extract sentences that meaningfully describe scenes/locations."""
        scene_contexts = defaultdict(list)

        for sentence in sentences:
            sentence_lower = sentence.lower()

            # Check if sentence contains any descriptive terms for scenes
            has_descriptor = any(word in sentence_lower for word in self.all_scene_descriptors)
            if not has_descriptor:
                continue

            # Check if the sentence mentions any location
            for location in location_names:
                location_pattern = r'\b' + re.escape(location) + r'\b'
                if re.search(location_pattern, sentence, re.IGNORECASE):
                    # Sentence mentions this location and has descriptive content
                    scene_contexts[location].append(sentence)
                    break

        return scene_contexts

    def analyze_character_descriptions(self, contexts):
        """Analyze character descriptions to extract key visual attributes."""
        appearance = []
        clothing = []
        accessories = []
        expressions = []

        for sentence in contexts:
            sentence_lower = sentence.lower()

            # Check each category of descriptors
            for word in self.character_descriptors['appearance']:
                if word in sentence_lower:
                    pattern = r'((\w+\s+){0,3}' + re.escape(word) + r'(\s+\w+){0,3})'
                    matches = re.findall(pattern, sentence_lower)
                    if matches:
                        appearance.extend([match[0] for match in matches])

            for word in self.character_descriptors['clothing']:
                if word in sentence_lower:
                    pattern = r'((\w+\s+){0,3}' + re.escape(word) + r'(\s+\w+){0,3})'
                    matches = re.findall(pattern, sentence_lower)
                    if matches:
                        clothing.extend([match[0] for match in matches])

            for word in self.character_descriptors['accessories']:
                if word in sentence_lower:
                    pattern = r'((\w+\s+){0,3}' + re.escape(word) + r'(\s+\w+){0,3})'
                    matches = re.findall(pattern, sentence_lower)
                    if matches:
                        accessories.extend([match[0] for match in matches])

            for word in self.character_descriptors['expressions']:
                if word in sentence_lower:
                    pattern = r'((\w+\s+){0,3}' + re.escape(word) + r'(\s+\w+){0,3})'
                    matches = re.findall(pattern, sentence_lower)
                    if matches:
                        expressions.extend([match[0] for match in matches])

        # Remove duplicates and clean up
        appearance = self._clean_attribute_list(appearance)
        clothing = self._clean_attribute_list(clothing)
        accessories = self._clean_attribute_list(accessories)
        expressions = self._clean_attribute_list(expressions)

        return {
            'appearance': appearance[:3],  # Limit to top 3 from each category
            'clothing': clothing[:2],
            'accessories': accessories[:2],
            'expressions': expressions[:1]
        }

    def analyze_scene_descriptions(self, contexts):
        """Analyze scene descriptions to extract key visual attributes."""
        appearance = []
        structure = []
        landscape = []
        details = []

        for sentence in contexts:
            sentence_lower = sentence.lower()

            # Check each category of descriptors
            for word in self.scene_descriptors['appearance']:
                if word in sentence_lower:
                    pattern = r'((\w+\s+){0,3}' + re.escape(word) + r'(\s+\w+){0,3})'
                    matches = re.findall(pattern, sentence_lower)
                    if matches:
                        appearance.extend([match[0] for match in matches])

            for word in self.scene_descriptors['structure']:
                if word in sentence_lower:
                    pattern = r'((\w+\s+){0,3}' + re.escape(word) + r'(\s+\w+){0,3})'
                    matches = re.findall(pattern, sentence_lower)
                    if matches:
                        structure.extend([match[0] for match in matches])

            for word in self.scene_descriptors['landscape']:
                if word in sentence_lower:
                    pattern = r'((\w+\s+){0,3}' + re.escape(word) + r'(\s+\w+){0,3})'
                    matches = re.findall(pattern, sentence_lower)
                    if matches:
                        landscape.extend([match[0] for match in matches])

            for word in self.scene_descriptors['details']:
                if word in sentence_lower:
                    pattern = r'((\w+\s+){0,3}' + re.escape(word) + r'(\s+\w+){0,3})'
                    matches = re.findall(pattern, sentence_lower)
                    if matches:
                        details.extend([match[0] for match in matches])

        # Remove duplicates and clean up
        appearance = self._clean_attribute_list(appearance)
        structure = self._clean_attribute_list(structure)
        landscape = self._clean_attribute_list(landscape)
        details = self._clean_attribute_list(details)

        return {
            'appearance': appearance[:2],  # Limit to top results from each category
            'structure': structure[:2],
            'landscape': landscape[:2],
            'details': details[:2]
        }

    def _clean_attribute_list(self, attributes):
        """Clean up a list of extracted attributes."""
        # Remove duplicates while preserving order
        seen = set()
        unique_attrs = []
        for attr in attributes:
            # Clean up the attribute
            attr = re.sub(r'[.,;:!?"]', '', attr).strip()
            attr = re.sub(r'\s+', ' ', attr)

            # Skip empty or very short attributes
            if len(attr) < 3:
                continue

            # Skip if mostly stopwords
            words = attr.lower().split()
            if sum(1 for word in words if word not in self.stop_words) <= 1:
                continue

            # Add if not seen before
            if attr.lower() not in seen:
                seen.add(attr.lower())
                unique_attrs.append(attr)

        return unique_attrs

    def generate_character_prompt(self, character_name, attributes, contexts):
        """Generate a rich, detailed prompt for an image generation model."""
        if not attributes and not contexts:
            return f"Portrait of {character_name}, a character from a novel."

        prompt_parts = [f"Detailed portrait of {character_name}"]

        # Add appearance details
        if attributes.get('appearance'):
            prompt_parts.append("with " + ", ".join(attributes['appearance']))

        # Add clothing details
        if attributes.get('clothing'):
            prompt_parts.append("wearing " + ", ".join(attributes['clothing']))

        # Add accessories
        if attributes.get('accessories'):
            prompt_parts.append("carrying " + ", ".join(attributes['accessories']))

        # Add expression
        if attributes.get('expressions'):
            prompt_parts.append("with " + ", ".join(attributes['expressions']))

        # Finalize the prompt
        prompt = ". ".join(prompt_parts)

        # Add an example sentence if available
        if contexts and len(prompt_parts) <= 2:  # Not many details extracted
            best_context = max(contexts[:5], key=len)
            clean_context = re.sub(r'[.,;:!?"]', '', best_context).strip()
            if len(clean_context) > 20:
                prompt += f". From context: '{best_context}'"

        return prompt + ". High quality, detailed character illustration from a novel."

    def generate_scene_prompt(self, scene_name, attributes, contexts):
        """Generate a rich, detailed prompt for an image generation model."""
        if not attributes and not contexts:
            return f"A scene depicting {scene_name} from a novel."

        prompt_parts = [f"Detailed illustration of {scene_name}"]

        # Add appearance details
        if attributes.get('appearance'):
            prompt_parts.append("with " + ", ".join(attributes['appearance']) + " atmosphere")

        # Add structure details
        scene_type = ""
        if attributes.get('structure'):
            structure_text = ", ".join(attributes['structure'])
            prompt_parts.append("featuring " + structure_text)
            # Try to determine scene type
            for structure in self.scene_descriptors['structure']:
                if structure in " ".join(attributes['structure']).lower():
                    scene_type = structure
                    break

        # Add landscape details
        if attributes.get('landscape'):
            landscape_text = ", ".join(attributes['landscape'])
            prompt_parts.append("with " + landscape_text)
            # Try to determine scene type if not found yet
            if not scene_type:
                for landscape in self.scene_descriptors['landscape']:
                    if landscape in " ".join(attributes['landscape']).lower():
                        scene_type = landscape
                        break

        # Add detail elements
        if attributes.get('details'):
            prompt_parts.append("containing " + ", ".join(attributes['details']))

        # Finalize the prompt
        prompt = ". ".join(prompt_parts)

        # Add scene type if identified
        if scene_type:
            prompt = prompt.replace(f"illustration of {scene_name}",
                                    f"illustration of {scene_name}, a {scene_type}")

        # Add an example sentence if available
        if contexts and len(prompt_parts) <= 2:  # Not many details extracted
            best_context = max(contexts[:5], key=len)
            clean_context = re.sub(r'[.,;:!?"]', '', best_context).strip()
            if len(clean_context) > 20:
                prompt += f". From context: '{best_context}'"

        return prompt + ". High quality, detailed scene illustration from a novel."

    def analyze_book(self, file_path, max_entities=15):
        """Process a book file and extract character and scene descriptions."""
        print(f"Processing file: {file_path}...")

        # Extract and preprocess text
        text = self.extract_text(file_path)
        if not text:
            return {}, {}

        print(f"Text extracted ({len(text)} characters). Preprocessing...")
        sentences = self.preprocess_text(text)
        print(f"Preprocessed into {len(sentences)} sentences.")

        # Identify key entities
        print("Identifying key characters and locations...")
        character_groups, locations = self.identify_key_entities(text)

        # Limit the number of entities to analyze for performance
        top_characters = dict(list(character_groups.items())[:max_entities])
        top_locations = list(locations)[:max_entities]

        print(f"Found {len(top_characters)} main characters and {len(top_locations)} locations.")

        # Extract contexts for characters and locations
        print("Extracting descriptive contexts...")
        character_contexts = self.extract_character_contexts(sentences, top_characters)
        scene_contexts = self.extract_scene_contexts(sentences, top_locations)

        # Generate prompts
        print("Generating image prompts...")
        character_prompts = {}
        for character, contexts in character_contexts.items():
            if contexts:
                attributes = self.analyze_character_descriptions(contexts)
                prompt = self.generate_character_prompt(character, attributes, contexts)
                character_prompts[character] = {
                    'prompt': prompt,
                    'attributes': attributes,
                    'sample_contexts': contexts[:3]
                }

        scene_prompts = {}
        for scene, contexts in scene_contexts.items():
            if contexts:
                attributes = self.analyze_scene_descriptions(contexts)
                prompt = self.generate_scene_prompt(scene, attributes, contexts)
                scene_prompts[scene] = {
                    'prompt': prompt,
                    'attributes': attributes,
                    'sample_contexts': contexts[:3]
                }

        return character_prompts, scene_prompts


def main(file_path):
    """Process a book file and print image-ready prompts for characters and scenes."""
    # Load spaCy model - handle potential models
    global nlp
    try:
        # Try to load the larger model first
        print("Loading spaCy model (trf version)...")
        try:
            nlp = spacy.load("en_core_web_trf")
        except OSError:
            print("Transformer model not available, falling back to standard model...")
            try:
                nlp = spacy.load("en_core_web_lg")
            except OSError:
                print("Large model not available, falling back to medium model...")
                try:
                    nlp = spacy.load("en_core_web_md")
                except OSError:
                    print("Medium model not available, falling back to small model...")
                    nlp = spacy.load("en_core_web_sm")
    except Exception as e:
        print(f"Error loading spaCy models: {e}")
        print("Please install at least one spaCy model with: python -m spacy download en_core_web_sm")
        return

    analyzer = BookAnalyzer()
    character_prompts, scene_prompts = analyzer.analyze_book(file_path)

    print("\n" + "=" * 80)
    print("CHARACTER IMAGE PROMPTS")
    print("=" * 80 + "\n")

    for character, data in character_prompts.items():
        print(f"\n{character}:")
        print("-" * 50)
        print(f"PROMPT: {data['prompt']}")
        print("-" * 50)
        print("ATTRIBUTES:")
        for category, attrs in data['attributes'].items():
            if attrs:
                print(f"  {category.capitalize()}: {', '.join(attrs)}")
        print("-" * 50)
        print("SAMPLE CONTEXTS:")
        for i, context in enumerate(data['sample_contexts'], 1):
            print(f"  {i}. {context}")
        print("=" * 80)

    print("\n" + "=" * 80)
    print("SCENE IMAGE PROMPTS")
    print("=" * 80 + "\n")

    for scene, data in scene_prompts.items():
        print(f"\n{scene}:")
        print("-" * 50)
        print(f"PROMPT: {data['prompt']}")
        print("-" * 50)
        print("ATTRIBUTES:")
        for category, attrs in data['attributes'].items():
            if attrs:
                print(f"  {category.capitalize()}: {', '.join(attrs)}")
        print("-" * 50)
        print("SAMPLE CONTEXTS:")
        for i, context in enumerate(data['sample_contexts'], 1):
            print(f"  {i}. {context}")
        print("=" * 80)


if __name__ == "__main__":
    file_path = "Reading-Harry-Potter-Chapter-1-2.pdf"  # Change to your actual file path
    main(file_path)
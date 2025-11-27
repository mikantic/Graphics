using UnityEngine;
using Core.Languages;
using System.Linq;
using System.Collections;
using System.Collections.Generic;

namespace Graphics.Languages
{
    public class LanguageReadout : MonoBehaviour
    {
        [SerializeField] private string _input;
        [SerializeField] private string _output;
        [SerializeField] private Language _language;
        [SerializeField] private AudioSource _audio;

        private IEnumerator PlaySounds(List<List<Sound>> sounds)
        {
            yield return new WaitForSeconds(2f);

            foreach (List<Sound> seciton in sounds)
            {
                foreach (Sound sound in seciton)
                {
                    AudioClip clip = _language.GetAudio(sound);
                    _audio.clip = clip;
                    _audio.Play();
                    yield return new WaitUntil(() => !_audio.isPlaying);
                    yield return new WaitForSeconds(0.05f);
                }
                yield return new WaitForSeconds(0.1f);
            }
        }

        private void Start()
        {
            _output = string.Join(" ", _language?.Translate(_input));
            StartCoroutine(PlaySounds(_input.GetSounds().Select(section => section.Select(sound => _language.Translate(sound)).ToList()).ToList()));
            Debug.Log($"_input {_input}  _output {_output}");
        }

        private void OnValidate()
        {
            _output = string.Join(" ", _language?.Translate(_input));
            Debug.Log($"_input {_input}  _output {_output}");
        }
    }
}
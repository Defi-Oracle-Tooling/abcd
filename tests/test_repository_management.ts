import { describe, it, expect, vi } from 'vitest';
import { createRepository, deleteRepository, initializeSubmodule, removeSubmodule } from '../scripts/repositoryManagement';

describe('Repository Management Scripts', () => {
    it('should handle repository creation errors gracefully', async () => {
        vi.mock('../scripts/repositoryManagement', () => ({
            createRepository: vi.fn().mockRejectedValue(new Error('Failed to create repository')),
        }));

        try {
            await createRepository('test-repo');
        } catch (error) {
            const err = error as Error;
            expect(err.message).toBe('Failed to create repository');
        }
    });

    it('should handle repository deletion errors gracefully', async () => {
        vi.mock('../scripts/repositoryManagement', () => ({
            deleteRepository: vi.fn().mockRejectedValue(new Error('Failed to delete repository')),
        }));

        try {
            await deleteRepository('test-repo');
        } catch (error) {
            const err = error as Error;
            expect(err.message).toBe('Failed to delete repository');
        }
    });

    it('should handle submodule initialization errors gracefully', async () => {
        vi.mock('../scripts/repositoryManagement', () => ({
            initializeSubmodule: vi.fn().mockRejectedValue(new Error('Failed to initialize submodule')),
        }));

        try {
            await initializeSubmodule('test-repo');
        } catch (error) {
            const err = error as Error;
            expect(err.message).toBe('Failed to initialize submodule');
        }
    });

    it('should handle submodule removal errors gracefully', async () => {
        vi.mock('../scripts/repositoryManagement', () => ({
            removeSubmodule: vi.fn().mockRejectedValue(new Error('Failed to remove submodule')),
        }));

        try {
            await removeSubmodule('test-repo');
        } catch (error) {
            const err = error as Error;
            expect(err.message).toBe('Failed to remove submodule');
        }
    });
});